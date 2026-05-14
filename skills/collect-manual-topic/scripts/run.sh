#!/usr/bin/env bash
set -euo pipefail
INPUT_FILE="${INPUT_FILE:-/dev/stdin}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/collect-manual-topic_${RUN_ID}.json}"
python3 - "$INPUT_FILE" "$OUTPUT_FILE" <<'PY'
import datetime, json, os, sys
input_file, output_file = sys.argv[1], sys.argv[2]
raw = sys.stdin.read() if input_file == "/dev/stdin" else open(input_file, encoding="utf-8").read()
raw = raw.strip()
prompt = ""
if raw:
    try:
        data = json.loads(raw)
        if isinstance(data, dict):
            for key in ("prompt", "topic", "message", "text"):
                value = data.get(key)
                if isinstance(value, str) and value.strip():
                    prompt = value.strip()
                    break
        elif isinstance(data, str):
            prompt = data.strip()
    except json.JSONDecodeError:
        prompt = raw
if not prompt:
    raise SystemExit("manual prompt or topic is required")
os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)
with open(output_file, "w", encoding="utf-8") as fh:
    json.dump({
        "run_id": os.environ.get("RUN_ID", ""),
        "user_prompt": prompt,
        "topic": prompt,
        "created_at": datetime.datetime.now(datetime.timezone.utc).isoformat()
    }, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
PY
