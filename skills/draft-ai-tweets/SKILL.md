---
id: draft-ai-tweets
name: Draft AI Tweets
version: 1.0.0
description: Generate AI-related tweet drafts for email approval and persist draft history.
user_invocable: false
always: false
requires:
  bins: [bash, python3]
  env: [RUN_ID, PG_CONNECTION_STRING]
primary_env: PG_CONNECTION_STRING
input_path: /tmp/retrieve-ai-trends_${RUN_ID}.json
output_path: /tmp/draft-ai-tweets_${RUN_ID}.json
depends_on: [retrieve-ai-trends, load-audience-notes]
---

## Purpose

Generate AI-related tweet drafts using the manual prompt/topic, current Twitter/X AI trend context, and stored target audience notes, then persist draft history for the approval workflow.

## I/O Contract

- **Input:** `/tmp/retrieve-ai-trends_${RUN_ID}.json` plus `/tmp/load-audience-notes_${RUN_ID}.json`, containing trend context, prompt/topic, and audience notes.
- **Output:** `/tmp/draft-ai-tweets_${RUN_ID}.json`, containing draft records with `id`, `user_prompt`, `trend_context`, `draft_text`, `approval_channel`, `approval_status`, and `created_at`.
- **DB Write:** `result_tweet_drafts` via `${PROJECT_ROOT}/scripts/data_writer.py` upsert on `id`.

## Notes

Generated content is draft-only and must be reviewed by the user through email. This skill does not post to Twitter/X or perform replies, likes, retweets, follows, DMs, analytics, or lead-generation actions.
