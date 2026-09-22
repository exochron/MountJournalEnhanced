#!/usr/bin/env bash

set -euo pipefail

readonly URL="https://addons.wago.io/addons/mount-journal-enhanced"
readonly OUTPUT="wago.json"

for cmd in curl grep sed jq; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Error: '$cmd' is required." >&2
        exit 1
    }
done

html="$(mktemp)"
trap 'rm -f "$html"' EXIT

curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --retry 3 \
    --retry-delay 2 \
    --connect-timeout 10 \
    --max-time 30 \
    -A "Mozilla/5.0" \
    "$URL" > "$html"

# The application state is embedded in the <div id="app"> element.
app_line="$(
    grep '<div id="app"' "$html" |
    head -n1
)"

if [[ -z "$app_line" ]]; then
    echo "Error: <div id=\"app\"> not found." >&2
    exit 1
fi

# Extract the data-page attribute.
payload="$(
    printf '%s\n' "$app_line" |
    sed -n 's/.*data-page="\([^"]*\)".*/\1/p'
)"

if [[ -z "$payload" ]]; then
    echo "Error: data-page attribute not found." >&2
    exit 1
fi

# Decode HTML entities used inside the attribute.
payload="$(
    printf '%s' "$payload" |
    sed \
        -e 's/&quot;/"/g' \
        -e 's/&amp;/\&/g' \
        -e "s/&#39;/'/g" \
        -e 's/&lt;/</g' \
        -e 's/&gt;/>/g'
)"

# Verify that what we extracted is actually JSON.
if ! printf '%s' "$payload" | jq empty >/dev/null 2>&1; then
    echo "Error: data-page is not valid JSON." >&2
    exit 1
fi

# Show the top-level structure while developing:
# printf '%s\n' "$payload" | jq 'keys'

# Extract the download count.
#
# The exact property path depends on the Wago payload structure.
# This searches recursively for an object property named "downloads"
# and takes the first numeric value.
downloads="$(
    printf '%s' "$payload" |
    jq -r '.props.metadata.download_count'
)"

if [[ -z "$downloads" ]]; then
    echo "Error: download count not found in Wago JSON payload." >&2
    exit 1
fi

jq -n \
    --argjson downloads "$downloads" \
    --arg url "$URL" \
    --arg fetched_at "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
    '{
        downloads: $downloads,
        url: $url,
        fetched_at: $fetched_at
    }' > "${OUTPUT}.tmp"

mv "${OUTPUT}.tmp" "$OUTPUT"

echo "Wago downloads: $downloads"
echo "Written to: $OUTPUT"