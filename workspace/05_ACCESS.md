# Step 5 of 5 — Access

## User Access

### Authorized Teams

| Team               | Access Level | Members (approx) |
|--------------------|-------------|-------------------|
| Requesting user | operator | User who supplies prompts and reviews email drafts. |
| Workspace administrators | admin | Admins for connectors, schema, and deployment. |

### Restricted From

| Team / Role          | Reason                          |
|----------------------|---------------------------------|
| Twitter/X publishing automation | Posting and engagement actions are prohibited. |

## HiTL Approvers

| Skill                | Action                         | Approver             | Fallback Approver    |
|----------------------|--------------------------------|----------------------|----------------------|
| collect-manual-topic | Supply prompt/topic. | Requesting user | Retry with a clear AI topic. |
| email-drafts-for-approval | Review drafts by email outside the agent. | Requesting user | Retry after confirming email configuration. |

## Model Configuration

| Field                | Value                          |
|----------------------|--------------------------------|
| **Primary Model**    | OpenClaw default runtime model   |
| **Fallback Model**   | OpenClaw fallback runtime model  |

## Token Budget

| Field                  | Value                  |
|------------------------|------------------------|
| **Monthly Budget**     | 250000 tokens |
| **Alert Threshold**    | 200000 tokens |
| **Auto-Pause on Limit**| Yes |

## Security & Permissions

| Permission                         | Allowed    |
|------------------------------------|------------|
| Read manual request input | ✅ |
| Read Twitter/X trend/source data | ✅ |
| Read result_target_audience_notes | ✅ |
| Write result_tweet_drafts | ✅ |
| Send approval email through Resend | ✅ |
| Post or engage on Twitter/X | ❌ |
| Analytics reporting or lead generation | ❌ |
