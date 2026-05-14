#!/usr/bin/env bash
set -euo pipefail
INPUT_FILE="${INPUT_FILE:-/tmp/collect-manual-topic_${RUN_ID}.json}"
OUTPUT_FILE="${OUTPUT_FILE:-/tmp/retrieve-ai-trends_${RUN_ID}.json}"
python3 - "$INPUT_FILE" "$OUTPUT_FILE" <<'PY'
import base64, datetime, hashlib, hmac, json, os, secrets, sys, time, urllib.parse, urllib.request, urllib.error
for name in ("TWITTER_API_KEY","TWITTER_API_SECRET","TWITTER_ACCESS_TOKEN","TWITTER_ACCESS_TOKEN_SECRET"):
    if not os.environ.get(name):
        raise SystemExit(f"{name} is required")
input_file, output_file = sys.argv[1], sys.argv[2]
with open(input_file, encoding="utf-8") as fh:
    request = json.load(fh)
topic = request.get("topic") or request.get("user_prompt") or "AI"
url = "https://api.twitter.com/2/tweets/search/recent"
params = {"query": '(AI OR "artificial intelligence") lang:en -is:retweet', "max_results": "10", "tweet.fields": "created_at,public_metrics"}
consumer_key=os.environ["TWITTER_API_KEY"]; consumer_secret=os.environ["TWITTER_API_SECRET"]
token=os.environ["TWITTER_ACCESS_TOKEN"]; token_secret=os.environ["TWITTER_ACCESS_TOKEN_SECRET"]
oauth = {"oauth_consumer_key": consumer_key, "oauth_nonce": secrets.token_hex(16), "oauth_signature_method": "HMAC-SHA1", "oauth_timestamp": str(int(time.time())), "oauth_token": token, "oauth_version": "1.0"}
def enc(v): return urllib.parse.quote(str(v), safe="")
base_params = {**params, **oauth}
param_string = "&".join(f"{enc(k)}={enc(base_params[k])}" for k in sorted(base_params))
base_string = "&".join(["GET", enc(url), enc(param_string)])
signing_key = f"{enc(consumer_secret)}&{enc(token_secret)}".encode()
oauth["oauth_signature"] = base64.b64encode(hmac.new(signing_key, base_string.encode(), hashlib.sha1).digest()).decode()
auth = "OAuth " + ", ".join(f'{enc(k)}="{enc(v)}"' for k,v in sorted(oauth.items()))
req = urllib.request.Request(url + "?" + urllib.parse.urlencode(params), headers={"Authorization": auth, "User-Agent": "TwitterAuto/1.0"})
try:
    with urllib.request.urlopen(req, timeout=30) as resp:
        status = resp.status; body = resp.read().decode("utf-8")
except urllib.error.HTTPError as e:
    body = e.read().decode("utf-8", errors="replace")[:800]
    for secret_name in ("TWITTER_API_KEY","TWITTER_API_SECRET","TWITTER_ACCESS_TOKEN","TWITTER_ACCESS_TOKEN_SECRET"):
        body = body.replace(os.environ.get(secret_name,""), "[REDACTED]")
    print(f"Twitter/X source request failed with HTTP {e.code}: {body}", file=sys.stderr)
    raise SystemExit(1)
if status < 200 or status >= 300:
    print(f"Twitter/X source request failed with HTTP {status}", file=sys.stderr)
    raise SystemExit(1)
payload = json.loads(body)
items = [{"id": t.get("id"), "text": t.get("text"), "created_at": t.get("created_at"), "public_metrics": t.get("public_metrics", {})} for t in payload.get("data", [])]
os.makedirs(os.path.dirname(output_file) or ".", exist_ok=True)
with open(output_file, "w", encoding="utf-8") as fh:
    json.dump({"run_id": os.environ.get("RUN_ID", ""), "topic": topic, "source": "Twitter/X", "retrieved_at": datetime.datetime.now(datetime.timezone.utc).isoformat(), "trend_context": {"items": items}}, fh, ensure_ascii=False, indent=2)
    fh.write("\n")
PY
