#!/bin/bash

set -euo pipefail

export OVERWRITE=${OVERWRITE:-0}

# TODO handle this better...
TPM="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
  git clone https://github.com/tmux-plugins/tpm "$TPM"
fi
NVM="$HOME/.config/nvm"
if [ ! -d "$NVM" ]; then
  git clone https://github.com/nvm-sh/nvm "$NVM"
fi

# TODO move this elsewhere?
# Base flavours paths
FLAVOUR_FILES="$( \
  egrep '^file' home/config/flavours/config.toml \
    | sed 's/file = "\(.*\)"/\1/g' \
    | sed 's;^~;'$HOME';' \
    | sort \
    | uniq \
)"
while IFS= read -r FILE; do
   mkdir -p $(dirname $FILE)
done <<< "$FLAVOUR_FILES"

export SRC_DIR="$(realpath home)"
export DST_DIR="$HOME"
function linkfile {
  SRC_FILE="$1"
  REL_NAME="$(realpath --relative-to="$SRC_DIR" "$SRC_FILE")"
  DST_FILE="$HOME/.$REL_NAME"

  echo -n "$DST_FILE..."

  if [[ -L "$DST_FILE" ]] && [[ "$(readlink "$DST_FILE")" = "$SRC_FILE" ]]; then
    echo "unchanged"
  elif [[ -L "$DST_FILE" ]] && [[ "$OVERWRITE" -eq 1 ]]; then
    ln -fs "$SRC_FILE" "$DST_FILE"
    echo "replaced"
  elif [[ ! -e "$DST_FILE" ]]; then
    mkdir -p "$(dirname $DST_FILE)"
    ln -s "$SRC_FILE"  "$DST_FILE"
    echo "created"
  else
    echo "not replacing"
    exit 1
  fi
}
export -f linkfile
find "$SRC_DIR" -type f -print0 | xargs -n1 -0 bash -c 'linkfile "$@"' --
