# Workflow — End-to-End Process Flow

Executed by the [Lobster runtime](https://github.com/openclaw/lobster) via `lobster run workflows/main.yaml`.
Steps run **sequentially** in the order shown below.

## Workflow Steps

1. **provision-schema** → `run: python3 scripts/data_writer.py provision` (timeout_ms=30000)
2. **collect-manual-topic** → skill `collect-manual-topic` (stdin={{ input }}, timeout_ms=120000, retry=0)
3. **retrieve-ai-trends** → skill `retrieve-ai-trends` (stdin={{ steps.collect-manual-topic.output }}, timeout_ms=180000, retry=1)
4. **load-audience-notes** → skill `load-audience-notes` (stdin={{ steps.collect-manual-topic.output }}, timeout_ms=120000, retry=1)
5. **draft-ai-tweets** → skill `draft-ai-tweets` (stdin={{ steps.retrieve-ai-trends.output }}, timeout_ms=180000, retry=0)
6. **email-drafts-for-approval** → skill `email-drafts-for-approval` (stdin={{ steps.draft-ai-tweets.output }}, timeout_ms=180000, retry=1)

## Diagram

```
provision-schema → collect-manual-topic → retrieve-ai-trends → load-audience-notes → draft-ai-tweets → email-drafts-for-approval
```
