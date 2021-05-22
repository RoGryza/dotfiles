#!/bin/bash

set -euo pipefail

BUILD=.build
DRY_RUN=
DRY_RUN_CMD=
VERBOSE=

function errecho {
  >&2 echo "$@"
}

# Parse options
for opt in "$@"; do
  case "$opt" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    *)
      errecho "Unknown option: '$opt'"
      exit 1
      ;;
  esac
done

if [[ -n "$DRY_RUN" ]]; then
  DRY_RUN_CMD="echo"
  echo "Dry run enabled, won't make changes"
fi
if [[ -n "$VERBOSE" ]]; then
  set -x
fi

REQUIRED_CMDS=()
function df_export_check {
  local TYPE=
  local CMD=
  for opt in "$@"; do
    case "$opt" in
      --type=*)
        TYPE="${opt#*=}"
        ;;
      --cmd=*)
        CMD="${opt#*=}"
        ;;
      *)
        errecho "df_export_check: invalid option '$opt'"
        return 1
        ;;
    esac
  done
  case "$TYPE" in
    cmd_exists)
      if [ -z "$CMD" ]; then
        errecho "df_export_check: --cmd is required for type '$TYPE'"
        return 1
      fi
      REQUIRED_CMDS+=("$CMD")
      ;;
    "")
      errecho "df_export_check: --type is required"
      return 1
  esac
}

FILE_FILES=()
declare -A FILE_TYPES
declare -A FILE_MODES
declare -A FILE_CONTENTS
declare -A FILE_ONCHANGE
function df_export_file {
  local NAME=
  local TYPE=
  local MODE=
  local CONTENT=
  local ONCHANGE=
  for opt in "$@"; do
    case "$opt" in
      --name=*)
        NAME="${opt#*=}"
        ;;
      --type=*)
        TYPE="${opt#*=}"
        ;;
      --mode=*)
        MODE="${opt#*=}"
        ;;
      --content=*)
        CONTENT="${opt#*=}"
        ;;
      --onChange=*)
        ONCHANGE="${opt#*=}"
        ;;
      *)
        errecho "df_export_file: invalid option '$opt'"
        return 1
        ;;
    esac
  done
  FILE_FILES+=("$NAME")
  FILE_TYPES["$NAME"]="$TYPE"
  if [[ -n "$MODE" ]]; then FILE_MODES["$NAME"]="$MODE"; fi
  if [[ -n "$CONTENT" ]]; then FILE_CONTENTS["$NAME"]="$CONTENT"; fi
  if [[ -n "$ONCHANGE" ]]; then FILE_ONCHANGE["$NAME"]="$ONCHANGE"; fi
}

source "$BUILD/exports.sh"
mkdir -p "$BUILD"

HOST_MODULE='(import "hosts.jsonnet").home'
MODULES=""
for MOD in modules/*; do
  echo "Adding module $(realpath --relative-to=modules ${MOD%.jsonnet})"
  if [ -f "$MOD/mod.jsonnet" ]; then
    MOD="$MOD/mod.jsonnet"
  fi
  MODULES="import '$MOD',$MODULES"
done

jsonnet build/make.jsonnet \
  --tla-code hostModule="$HOST_MODULE" \
  --tla-code modules="[$MODULES]" \
  --jpath . --multi "$BUILD" --create-output-dirs --string >/dev/null

echo -n "Checking requirements..."
CHECK_ERRORS=()

for CMD in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$CMD" &>/dev/null; then
    CHECK_ERRORS+=("Requred command '$CMD' not found in \$PATH")
  fi
done

if [ ${#CHECK_ERRORS[@]} -ne 0 ]; then
  echo
  for ERR in "${CHECK_ERRORS[@]}"; do
    errecho "$ERR"
  done
  exit 1
fi
echo " OK"

echo "Creating files..."
for FILE in "${FILE_FILES[@]}"; do
  FULLFILE="${FILE/\~/$HOME}"
  echo "$FILE..."
  case "${FILE_TYPES[$FILE]}" in
    dir)
      $DRY_RUN_CMD mkdir -p "$FULLFILE"
      ;;
    file)
      $DRY_RUN_CMD mkdir -p "$(dirname $FULLFILE)"
      $DRY_RUN_CMD cp "$BUILD/content/$FILE" "$FULLFILE"
      ;;
    link)
      $DRY_RUN_CMD mkdir -p "$(dirname $FULLFILE)"
      $DRY_RUN_CMD ln -fs "$(realpath -m ${FILE_CONTENTS[$FILE]/\~/$HOME})" "$FULLFILE"
      ;;
    http)
      # TODO how to validate cache?
      if [ ! -f "$FULLFILE" ]; then
        $DRY_RUN_CMD mkdir -p "$(dirname $FULLFILE)"
        $DRY_RUN_CMD curl -fLo "$FULLFILE" "${FILE_CONTENTS[$FILE]}"
      else
        echo "$FULLFILE already exists, not fetching"
      fi
      ;;
    *)
      echoerr "Invalid file type for '$FILE': '$TYPE'"
      exit 1
      ;;
  esac
  [ "${FILE_MODES[$FILE]+abc}" ] && $DRY_RUN_CMD chmod "${FILE_MODES[$FILE]}" "$FULLFILE"
done

echo "Done"
