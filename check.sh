#!/bin/bash
set -euo pipefail

echo -n "Checking requirements..."
ERRORS=()

function check_add_error {
  ERRORS+="$1"
}

source "$1"

if [ ${#ERRORS[@]} -ne 0 ]; then
  echo
  for ERR in "${ERRORS[@]}"; do
    >&2 echo "$ERR"
  done
  exit 1
fi
echo " OK"
