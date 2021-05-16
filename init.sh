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

#TODO check installed nerd fonts version
NERDFONT="FiraCode"
NERDFONTS_VERSION="2.1.0"
NERDFONT_MARKER="$HOME/.local/share/fonts/.$NERDFONT"
if [ ! -f "$NERDFONT_MARKER" ]; then
  CACHED="$HOME/.cache/nerdfonts/$NERDFONT.zip"
  if [ ! -f "$CACHED" ]; then
    mkdir -p "$(dirname "$CACHED")"
    wget -O "$CACHED" \
      "https://github.com/ryanoasis/nerd-fonts/releases/download/v$NERDFONTS_VERSION/$NERDFONT.zip"
  fi
  unzip "$CACHED" -d "$HOME/.local/share/fonts/"
  echo "$NERDFONTS_VERSION" > "$NERDFONT_MARKER"
  fc-cache -fv
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
function linkfile {
  SRC_FILE="$1"
  REL_NAME="$(realpath --relative-to="$SRC_DIR" "$SRC_FILE")"
  DST_FILE="$HOME/.$REL_NAME"

  echo -n "$DST_FILE..."

  if [[ -L "$DST_FILE" ]] && [[ "$(readlink "$DST_FILE")" = "$SRC_FILE" ]]; then
    echo "unchanged"
  elif [[ "$OVERWRITE" -eq 1 ]]; then
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

# TODO handle this better...
ln -fs "$HOME/.xinitrc" "$HOME/.xsession"
mkdir -p "$HOME/.config/x11"
ln -fs "$HOME/.xinitrc" "$HOME/.config/x11/nvidia-xinitrc"
