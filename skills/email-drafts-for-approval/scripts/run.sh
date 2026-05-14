#!/usr/bin/env bash
set -euo pipefail
INPUT_FILE="${INPUT_FILE:-/tmp/draft-ai-tweets_${RUN_ID}.json}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/email-drafts-for-approval_${RUN_ID}.json}"
python3 - "$INPUT_FILE" "$OUTPUT_FILE" <<'PY'
import datetime, html, json, os, sys, urllib.error, urllib.request
for name in ("RESEND_API_KEY", "EMAIL_FROM_ADDRESS", "RECIPIENT_EMAIL_ADDRESS"):
    if not os.environ.get(name):
        raise SystemExit(f"{name} is required")
input_file, output_file = sys.argv[1], sys.argv[2]
with open(input_file, encoding="utf-8") as fh: payload = json.load(fh)
drafts = payload.get("drafts", [])
if not drafts:
    raise SystemExit("at least one draft is required for approval email")
lines = ["Please review these AI tweet drafts for approval. No draft has been posted to Twitter/X.", ""]
for i, draft in enumerate(drafts, 1):
    lines.append(f"Draft {i}: {draft.get('draft_text','')}")
body_text = "\n\n".join(lines)
body_html = "<p>Please review these AI tweet drafts for approval. No draft has been posted to Twitter/X.</p>" + "".join(f"<h3>Draft {i}</h3><p>{html.escape(d.get('draft_text',''))}</p>" for i,d in enumerate(drafts,1))
email = {"from": os.environ["EMAIL_FROM_ADDRESS"], "to": [os.environ["RECIPIENT_EMAIL_ADDRESS"]], "subject": "TwitterAuto AI tweet drafts for approval", "text": body_text, "html": body_html}
req = urllib.request.Request("https://api.resend.com/emails", data=json.dumps(email).encode(), headers={"Authorization": "Bearer " + os.environ["RESEND_API_KEY"], "Content-Type": "application/json"}, method="POST")
try:
    with urllib.request.urlopen(req, timeout=30) as resp:
        status = resp.status; body = resp.read().decode("utf-8")
except urllib.error.HTTPError as e:
    body = e.read().decode("utf-8", errors="replace")[:800].replace(os.environ["RESEND_API_KEY"], "[REDACTED]")
    print(f"Resend email request failed with HTTP {e.code}: {body}", file=sys.stderr)
    raise SystemExit(1)
if status < 200 or status >= 300:
    print(f"Resend email request failed with HTTP {status}", file=sys.stderr)
    raise SystemExit(1)
result = json.loads(body) if body.strip() else {}
sent_at = datetime.datetime.now(datetime.timezone.utc).isoformat()
os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)
with open(output_file, "w", encoding="utf-8") as fh:
    json.dump({"run_id": os.environ.get("RUN_ID", ""), "approval_channel": "Email", "recipient": os.environ["RECIPIENT_EMAIL_ADDRESS"], "sent_at": sent_at, "resend": result}, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
PY
