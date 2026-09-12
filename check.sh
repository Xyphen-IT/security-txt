#!/bin/sh
# Sanity checks on security.txt (RFC 9116). Run in CI and before editing.
set -eu

f=${1:-security.txt}
fail() { echo "check: $*" >&2; exit 1; }

grep -q '^Contact: ' "$f" || fail "Contact field missing"
grep -q '^Expires: ' "$f" || fail "Expires field missing"
[ "$(grep -c '^Expires: ' "$f")" -eq 1 ] || fail "Expires must appear exactly once"

exp=$(sed -n 's/^Expires: //p' "$f")
case "$exp" in
    [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]*Z) ;;
    *) fail "Expires is not an ISO 8601 UTC timestamp: $exp" ;;
esac

exp_day=$(echo "$exp" | cut -c1-10)
today=$(date -u +%Y-%m-%d)
limit=$(date -u -d '+1 year' +%Y-%m-%d 2>/dev/null || date -u -v+1y +%Y-%m-%d)

[ "$exp_day" \> "$today" ] || fail "Expires ($exp_day) is in the past"
[ "$exp_day" \< "$limit" ] || fail "Expires ($exp_day) is more than a year out"

echo "check: ok (expires $exp_day)"
