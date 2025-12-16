#!/usr/bin/env bash

# -----------------------------
# CONFIG
# -----------------------------
OUTPUT_FILE="all_grants.json"
TMP_FILE="all_grants.tmp"
PER_PAGE=100
SORT_BY="date"
SORT_ORDER="asc"
API_URL="https://api.doge.gov/savings/grants"

# -----------------------------
# CLEAN START
# -----------------------------
rm -f "$OUTPUT_FILE" "$TMP_FILE"

# -----------------------------
# FETCH FIRST PAGE TO READ META
# -----------------------------
echo "Fetching page 1 to read metadata..."
first_response=$(curl -s "$API_URL?sort_by=$SORT_BY&sort_order=$SORT_ORDER&page=1&per_page=$PER_PAGE" \
                 -H "accept: application/json")

# extract meta safely
total_pages=$(echo "$first_response" | jq -s '[.[] | select(type=="object" and has("meta")) | .meta.pages] | first')
total_results=$(echo "$first_response" | jq -s '[.[] | select(type=="object" and ha]()
