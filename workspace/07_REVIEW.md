# Review — Final Summary Before Save

## Agent Card

| Field              | Value                          |
|--------------------|--------------------------------|
| **Name**           | 🐦 TwitterAuto |
| **ID**             | `twitterauto`           |
| **Version**        | 1.0.0 |
| **Scope**          | Create AI-related tweet drafts on demand from a manual topic, current Twitter/X AI trend context, and target audience notes, then email drafts for approval without posting.      |
| **Tone**           | clear, draft-focused, approval-oriented, AI-scoped             |
| **Model**          | OpenClaw default runtime model (primary), OpenClaw fallback runtime model (fallback) |
| **Token Budget**   | 250000 tokens/month |

## Skills Summary

| Skill                     | Mode         |
|---------------------------|--------------|
| Data Writer | 🟢 Auto |
| Result Query | 🟢 Auto |
| GitHub Action | 🟢 Auto |
| Collect Manual Topic | 🟢 Auto |
| Retrieve AI Trends | 🟢 Auto |
| Load Audience Notes | 🟢 Auto |
| Draft AI Tweets | 🟢 Auto |
| Email Drafts For Approval | 🟢 Auto |

## Post-Save Checklist

- [ ] Confirm platform-managed infrastructure variables are present.
- [ ] Configure Twitter/X and Resend credentials.
- [ ] Create target audience notes.
- [ ] Run check-environment.sh and test-workflow.sh.
- [ ] Submit a manual AI topic and verify draft-only email delivery.
