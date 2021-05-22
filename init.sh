#!/bin/bash

set -euo pipefail

BUILD=.build
mkdir -p "$BUILD"

HOST_MODULE='(import "hosts.jsonnet").home'
MODULES=""
for MOD in modules/*; do
  if [ -f "$MOD/mod.jsonnet" ]; then
    MOD="$MOD/mod.jsonnet"
  fi
  MODULES="import '$MOD',$MODULES"
done

jsonnet make.jsonnet \
  --tla-code hostModule="$HOST_MODULE" \
  --tla-code modules="[$MODULES]" > "$BUILD/manifest.json" \
  -J .

cat "$BUILD/manifest.json" | jq '.config.checks | join("")' -r > "$BUILD/check.sh"
./check.sh "$BUILD/check.sh"
echo "Running activation scripts..."
cat "$BUILD/manifest.json" | jq '.config.activation | join("; ")' -r | bash
# TODO escape file names
echo "Creating dirs..."
cat "$BUILD/manifest.json" | jq '.output.files | map(select(.type == "dir")) | map("mkdir -p \(.name) && chmod \(.mode) \(.name)") | join("; ")' -r | bash
# TODO wtf
# echo "Fetching HTTP files..."
# cat "$BUILD/manifest.json" | jq '.output.files | map(select(.type == "http")) | map("[ -f \(.name) ] || mkdir -p `dirname \(.name)` && curl -fLo \(.name) \(.content)") | join("; ")' -r | bash
echo "Creating files..."
while IFS= read -r f; do
  RAWNAME="$(echo "$f" | jq -r '.name')"
  NAME="${RAWNAME/\~/$HOME}"
  MODE="$(echo "$f" | jq -r '.mode')"
  echo -n "$NAME..."
  mkdir -p "$(dirname "$NAME")"
  rm -f "$NAME"
  echo "$f" | jq -r '.content' > "$NAME"
  chmod "$MODE" "$NAME"
  echo " OK"
done < <(cat "$BUILD/manifest.json" | jq -cr '.output.files | map(select(.type == "file")) | .[]')
