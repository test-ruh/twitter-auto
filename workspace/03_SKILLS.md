# Step 3 of 5 — Skills

## Added Skills

| #    | Skill ID                  | Skill Name               | Mode   | Risk Level | Description                |
|------|---------------------------|--------------------------|--------|------------|----------------------------|
| S1   | `data-writer` | Data Writer | Auto | Low | Provision, write, and query the agent database schema via scripts/data_writer.py. Use for all PostgreSQL operations and any result-table persistence. |
| S2   | `result-query` | Result Query | Auto | Low | Read stored records from the agent result tables for inspection and follow-up questions. |
| S3   | `github-action` | GitHub Action | Auto | Low | Git branch + PR workflow for syncing agent changes to GitHub. Creates feature branches, commits changes, and opens pull requests against main. NEVER pushes to main directly. MANDATORY for every agent. |
| S4   | `collect-manual-topic` | Collect Manual Topic | Auto | Low | Receive the on-demand user prompt or topic that starts AI tweet drafting. |
| S5   | `retrieve-ai-trends` | Retrieve AI Trends | Auto | Low | Retrieve current AI topic context from Twitter/X for draft generation. |
| S6   | `load-audience-notes` | Load Audience Notes | Auto | Low | Load stored target audience notes for drafting context. |
| S7   | `draft-ai-tweets` | Draft AI Tweets | Auto | Low | Generate AI tweet drafts for email approval and persist draft history. |
| S8   | `email-drafts-for-approval` | Email Drafts For Approval | Auto | Low | Send generated AI tweet drafts by email for human approval. |

## Skill Dependencies (Execution Order)

```
data-writer
result-query
github-action
collect-manual-topic
retrieve-ai-trends ← depends on collect-manual-topic
load-audience-notes ← depends on collect-manual-topic
draft-ai-tweets ← depends on retrieve-ai-trends, load-audience-notes
email-drafts-for-approval ← depends on draft-ai-tweets
```

## Execution Mode Summary

| Mode  | Count          |
|-------|----------------|
| HiTL  | 0              |
| Auto  | 8 |
