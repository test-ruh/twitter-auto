---
id: load-audience-notes
name: Load Audience Notes
version: 1.0.0
description: Load stored target audience notes for AI tweet drafting context.
user_invocable: false
always: false
requires:
  bins: [bash, python3]
  env: [RUN_ID, PG_CONNECTION_STRING]
primary_env: PG_CONNECTION_STRING
input_path: /tmp/collect-manual-topic_${RUN_ID}.json
output_path: /tmp/load-audience-notes_${RUN_ID}.json
depends_on: [collect-manual-topic]
---

## Purpose

Retrieve stored target audience notes from `result_target_audience_notes` so drafts can be directed toward the intended audience and support audience and engagement growth.

## I/O Contract

- **Input:** `/tmp/collect-manual-topic_${RUN_ID}.json`, containing the manual request context.
- **Output:** `/tmp/load-audience-notes_${RUN_ID}.json`, containing `run_id`, `loaded_at`, and `audience_notes` records with `id`, `notes`, `created_at`, and `updated_at`.
- **DB Write:** none.

## Notes

This skill reads target audience context only. It does not update notes, generate drafts, send email, post to Twitter/X, or perform Twitter/X engagement actions.
