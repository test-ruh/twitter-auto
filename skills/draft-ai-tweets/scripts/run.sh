#!/usr/bin/env bash
set -euo pipefail
INPUT_FILE="${INPUT_FILE:-/tmp/retrieve-ai-trends_${RUN_ID}.json}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/draft-ai-tweets_${RUN_ID}.json}"
AUDIENCE_FILE="${AUDIENCE_FILE:-/tmp/load-audience-notes_${RUN_ID}.json}"
PROJECT_ROOT="${PROJECT_ROOT:-$(pwd)}"
export PG_CONNECTION_STRING="${PG_CONNECTION_STRING:?PG_CONNECTION_STRING is required}"
python3 - "$INPUT_FILE" "$AUDIENCE_FILE" "$OUTPUT_FILE" <<'PY'
import datetime, json, os, re, sys, uuid, subprocess
trend_file, audience_file, output_file = sys.argv[1], sys.argv[2], sys.argv[3]
with open(trend_file, encoding="utf-8") as fh: trends = json.load(fh)
with open(audience_file, encoding="utf-8") as fh: audience = json.load(fh)
user_prompt = trends.get("topic") or audience.get("request", {}).get("user_prompt") or "AI"
items = trends.get("trend_context", {}).get("items", [])
trend_phrases = []
for item in items[:3]:
    text = re.sub(r"\s+", " ", item.get("text", "")).strip()
    if text:
        trend_phrases.append(text[:90])
audience_text = " ".join(n.get("notes", "") for n in audience.get("audience_notes", []) if n.get("notes"))[:180]
now = datetime.datetime.now(datetime.timezone.utc).isoformat()
base_context = trend_phrases[0] if trend_phrases else "current AI conversations on Twitter/X"
audience_clause = f" for this audience: {audience_text}" if audience_text else ""
draft_texts = [
    f"Draft: {user_prompt} — one AI angle worth watching now is {base_context}. What changes first: workflow, product, or trust?{audience_clause}"[:280],
    f"Draft: AI update for approval: {user_prompt}. Current Twitter/X AI context points to {base_context}. The useful question is what teams should do next.{audience_clause}"[:280],
    f"Draft: If you're tracking AI, connect {user_prompt} with today's signal: {base_context}. Practical adoption beats hype when the audience knows the tradeoff.{audience_clause}"[:280]
]
records = [{"id": str(uuid.uuid4()), "user_prompt": user_prompt, "trend_context": trends.get("trend_context", {}), "draft_text": text, "approval_channel": "Email", "approval_status": "pending_email_approval", "created_at": now, "sent_at": None} for text in draft_texts]
os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)
with open(output_file, "w", encoding="utf-8") as fh:
    json.dump({"run_id": os.environ.get("RUN_ID", ""), "drafts": records}, fh, ensure_ascii=False, indent=2); fh.write("\n")
writer = os.path.join(os.environ.get("PROJECT_ROOT", os.getcwd()), "scripts", "data_writer.py")
subprocess.run([
    "python3", writer, "write",
    "--table", "result_tweet_drafts",
    "--records", json.dumps(records, ensure_ascii=False),
    "--conflict", "id",
    "--run-id", os.environ.get("RUN_ID", ""),
], check=True)
PY
