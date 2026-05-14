#!/usr/bin/env bash
# Check required environment variables are set.
set -euo pipefail

missing=0
if [ -z "${TWITTER_API_KEY:-}" ]; then echo "MISSING: TWITTER_API_KEY"; missing=$((missing+1)); fi
if [ -z "${TWITTER_API_SECRET:-}" ]; then echo "MISSING: TWITTER_API_SECRET"; missing=$((missing+1)); fi
if [ -z "${TWITTER_ACCESS_TOKEN:-}" ]; then echo "MISSING: TWITTER_ACCESS_TOKEN"; missing=$((missing+1)); fi
if [ -z "${TWITTER_ACCESS_TOKEN_SECRET:-}" ]; then echo "MISSING: TWITTER_ACCESS_TOKEN_SECRET"; missing=$((missing+1)); fi
if [ -z "${RESEND_API_KEY:-}" ]; then echo "MISSING: RESEND_API_KEY"; missing=$((missing+1)); fi
if [ -z "${RECIPIENT_EMAIL_ADDRESS:-}" ]; then echo "MISSING: RECIPIENT_EMAIL_ADDRESS"; missing=$((missing+1)); fi
if [ -z "${EMAIL_FROM_ADDRESS:-}" ]; then echo "MISSING: EMAIL_FROM_ADDRESS"; missing=$((missing+1)); fi

if [ $missing -gt 0 ]; then
    echo "$missing required env var(s) missing"
    exit 1
fi
echo "OK: all required env vars set"
