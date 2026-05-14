# 🐦 TwitterAuto

Create AI-related tweet drafts on demand from a manual topic, current Twitter/X AI trend context, and target audience notes, then email drafts for approval without posting.

## Quick Start

```bash
git clone git@github.com:${GITHUB_OWNER}/twitterauto.git
cd twitterauto

# 1. Configure
cp .env.example .env
# Edit .env with your credentials (see "Required Environment Variables" below)

# 2. One-shot setup: validates env, installs deps, provisions DB, registers cron
chmod +x setup.sh
./setup.sh
```

## Manual Setup (if you prefer step-by-step)

```bash
cp .env.example .env             # then edit it
set -a; source .env; set +a       # load vars into the current shell
bash check-environment.sh         # verify everything required is set
bash install-dependencies.sh      # pip install psycopg2-binary, pyyaml
python3 scripts/data_writer.py provision   # create tables in your schema
openclaw cron add --file cron/manual-tweet-draft-request.json
```

## Running

```bash
bash test-workflow.sh             # run every skill in order locally (smoke test)
openclaw cron run --name manual-tweet-draft-request    # trigger manually
openclaw cron list                # see registered jobs
openclaw cron runs                # see run history
```

## Required Environment Variables

| Variable | Description |
|----------|-------------|
| `TWITTER_API_KEY` | Twitter/X API key |
| `TWITTER_API_SECRET` | Twitter/X API secret |
| `TWITTER_ACCESS_TOKEN` | Twitter/X access token |
| `TWITTER_ACCESS_TOKEN_SECRET` | Twitter/X access token secret |
| `RESEND_API_KEY` | Resend API key |
| `RECIPIENT_EMAIL_ADDRESS` | Approval recipient email address |
| `EMAIL_FROM_ADDRESS` | Verified Resend sender email address |

## Skills

| Skill | Mode | Description |
|-------|------|-------------|
| `data-writer` | Auto | Provision, write, and query the agent database schema via scripts/data_writer.py. Use for all PostgreSQL operations and any result-table persistence. |
| `result-query` | User-invocable | Read stored records from the agent result tables for inspection and follow-up questions. |
| `github-action` | User-invocable | Git branch + PR workflow for syncing agent changes to GitHub. Creates feature branches, commits changes, and opens pull requests against main. NEVER pushes to main directly. MANDATORY for every agent. |
| `collect-manual-topic` | User-invocable | Receive the on-demand user prompt or topic that starts AI tweet drafting. |
| `retrieve-ai-trends` | Auto | Retrieve current AI topic context from Twitter/X for draft generation. |
| `load-audience-notes` | Auto | Load stored target audience notes for drafting context. |
| `draft-ai-tweets` | Auto | Generate AI tweet drafts for email approval and persist draft history. |
| `email-drafts-for-approval` | Auto | Send generated AI tweet drafts by email for human approval. |

## Scheduled Jobs

| Job Name | Schedule | Notes |
|----------|----------|-------|
| `manual-tweet-draft-request` | `` | Timezone: UTC |


## Architecture

- **Runtime**: OpenClaw AI agent framework
- **Data Layer**: PostgreSQL via `scripts/data_writer.py`
- **Scheduling**: OpenClaw cron
- **Schema**: `org_{org_id}_a_twitterauto`

## Directory Structure

```
twitterauto/
├── README.md
├── openclaw.json
├── result-schema.yml
├── env-manifest.yml
├── .env.example
├── requirements.txt
├── .gitignore
├── check-environment.sh
├── install-dependencies.sh
├── test-workflow.sh
├── cron/
├── workflows/
├── scripts/
│   ├── data_writer.py
│   └── github_action.py
├── skills/
└── workspace/
    ├── SOUL.md
    ├── 01_IDENTITY.md
    ├── 02_RULES.md
    ├── 03_SKILLS.md
    ├── 04_TRIGGERS.md
    ├── 05_ACCESS.md
    ├── 06_WORKFLOW.md
    └── 07_REVIEW.md
```
