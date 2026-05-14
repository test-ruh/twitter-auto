---
id: retrieve-ai-trends
name: Retrieve AI Trends
version: 1.0.0
description: Retrieve current AI topic context from Twitter/X for draft generation.
user_invocable: false
always: false
requires:
  bins: [bash, python3]
  env: [RUN_ID, TWITTER_API_KEY, TWITTER_API_SECRET, TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_TOKEN_SECRET]
primary_env: TWITTER_API_KEY
input_path: /tmp/collect-manual-topic_${RUN_ID}.json
output_path: /tmp/retrieve-ai-trends_${RUN_ID}.json
depends_on: [collect-manual-topic]
---

## Purpose

Read current AI-related topic context from Twitter/X using the approved trends/source credentials so generated drafts can reflect current AI discussion.

## I/O Contract

- **Input:** `/tmp/collect-manual-topic_${RUN_ID}.json`, containing `user_prompt` or `topic`.
- **Output:** `/tmp/retrieve-ai-trends_${RUN_ID}.json`, containing `run_id`, `topic`, `source`, `retrieved_at`, and `trend_context` with current AI-related Twitter/X source items.
- **DB Write:** none.

## Notes

This skill performs Twitter/X read-only source retrieval. It does not post, reply, like, retweet, follow, send DMs, report analytics, or perform lead generation.
