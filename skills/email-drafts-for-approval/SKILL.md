---
id: email-drafts-for-approval
name: Email Drafts For Approval
version: 1.0.0
description: Send generated AI tweet drafts by email for human approval.
user_invocable: false
always: false
requires:
  bins: [bash, python3]
  env: [RUN_ID, RESEND_API_KEY, EMAIL_FROM_ADDRESS, RECIPIENT_EMAIL_ADDRESS]
primary_env: RESEND_API_KEY
input_path: /tmp/draft-ai-tweets_${RUN_ID}.json
output_path: /tmp/email-drafts-for-approval_${RUN_ID}.json
depends_on: [draft-ai-tweets]
---

## Purpose

Deliver generated AI tweet drafts to the requesting user's email inbox for human approval outside the agent.

## I/O Contract

- **Input:** `/tmp/draft-ai-tweets_${RUN_ID}.json`, containing generated AI tweet draft records.
- **Output:** `/tmp/email-drafts-for-approval_${RUN_ID}.json`, containing `run_id`, `approval_channel`, `recipient`, `sent_at`, and Resend message metadata.
- **DB Write:** none.

## Notes

Email content must present all tweets as drafts for approval. This skill does not approve, post, reply, like, retweet, follow, DM, report analytics, or perform lead generation.
