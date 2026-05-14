#!/usr/bin/env bash
set -euo pipefail
INPUT_FILE="${INPUT_FILE:-/tmp/collect-manual-topic_${RUN_ID}.json}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/load-audience-notes_${RUN_ID}.json}"
python3 - "$INPUT_FILE" "$OUTPUT_FILE" <<'PY'
import datetime, json, os, sys
if not os.environ.get("PG_CONNECTION_STRING"):
    raise SystemExit("PG_CONNECTION_STRING is required")
input_file, output_file = sys.argv[1], sys.argv[2]
with open(input_file, encoding="utf-8") as fh:
    request = json.load(fh)
try:
    import psycopg
    with psycopg.connect(os.environ["PG_CONNECTION_STRING"]) as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id, notes, created_at, updated_at FROM result_target_audience_notes ORDER BY updated_at DESC")
            rows = cur.fetchall()
except ImportError:
    import psycopg2
    conn = psycopg2.connect(os.environ["PG_CONNECTION_STRING"])
    try:
        cur = conn.cursor(); cur.execute("SELECT id, notes, created_at, updated_at FROM result_target_audience_notes ORDER BY updated_at DESC")
        rows = cur.fetchall(); cur.close()
    finally:
        conn.close()
audience_notes = [{"id": str(r[0]), "notes": r[1], "created_at": r[2].isoformat() if hasattr(r[2], "isoformat") else str(r[2]), "updated_at": r[3].isoformat() if hasattr(r[3], "isoformat") else str(r[3])} for r in rows]
os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)
with open(output_file, "w", encoding="utf-8") as fh:
    json.dump({"run_id": os.environ.get("RUN_ID", ""), "request": request, "loaded_at": datetime.datetime.now(datetime.timezone.utc).isoformat(), "audience_notes": audience_notes}, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
PY
