---
id: collect-manual-topic
name: Collect Manual Topic
version: 1.0.0
description: Receive the on-demand user prompt or topic that starts AI tweet drafting.
user_invocable: true
always: false
requires:
  bins: [bash, python3]
  env: [RUN_ID]
primary_env: RUN_ID
input_path: /dev/stdin
output_path: /tmp/collect-manual-topic_${RUN_ID}.json
depends_on: []
---

## Purpose

Capture the requesting user's manual on-demand AI prompt or topic and normalize it for downstream trend retrieval, audience-context loading, drafting, and approval delivery.

## I/O Contract

- **Input:** `/dev/stdin` or `INPUT_FILE`, containing either raw prompt text or JSON with `prompt`, `topic`, `message`, or `text`.
- **Output:** `/tmp/collect-manual-topic_${RUN_ID}.json`, containing `run_id`, `user_prompt`, `topic`, and `created_at`.
- **DB Write:** none.

## Notes

This skill only captures manual input. It does not retrieve Twitter/X data, draft tweets, send email, post to Twitter/X, or perform engagement actions.
