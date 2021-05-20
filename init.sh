#!/bin/bash

set -euo pipefail

./requirements.sh

export OVERWRITE=${OVERWRITE:-0}

# TODO handle this better...
ANTIGEN="$HOME/.local/lib/zsh/antigen"
if [ ! -d "$ANTIGEN" ]; then
  mkdir -p "`dirname "$ANTIGEN"`"
  git clone https://github.com/zsh-users/antigen.git "$ANTIGEN"
fi
TPM="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM" ]; then
  mkdir -p "`dirname "$TPM"`"
  git clone https://github.com/tmux-plugins/tpm "$TPM"
fi
NVM="$HOME/.config/nvm"
if [ ! -d "$NVM" ]; then
  mkdir -p "`dirname "$NVM"`"
  git clone https://github.com/nvm-sh/nvm "$NVM"
fi
PLUG="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG" ]; then
  mkdir -p "`dirname "$PLUG"`"
  curl -fLo "$PLUG" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
       
# TODO what to do about per-host configs
DF_ENV="${DF_ENV:-}"
if [ "$DF_ENV" = home ]; then
  HAXE_LANGUAGE_SERVER="$HOME/.local/src/haxe_language_server"
  if [ ! -d "$HAXE_LANGUAGE_SERVER" ]; then
    mkdir -p "`dirname "$HAXE_LANGUAGE_SERVER"`"
    git clone https://github.com/vshaxe/haxe-language-server "$HAXE_LANGUAGE_SERVER"
  fi
  HAXE_LANGUAGE_SERVER_SCRIPT="$HAXE_LANGUAGE_SERVER/bin/server.js"
  if [ ! -f "$HAXE_LANGUAGE_SERVER_SCRIPT" ]; then
    cd "$HAXE_LANGUAGE_SERVER"
    yarn import
    yarn install
    npx lix run vshaxe-build -t language-server
  fi
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

# TODO handle this better...
ln -fs "$HOME/.xinitrc" "$HOME/.xsession"
mkdir -p "$HOME/.config/x11"
ln -fs "$HOME/.xinitrc" "$HOME/.config/x11/nvidia-xinitrc"

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

  echo -n "$DST_FILE... "

  if [[ -L "$DST_FILE" ]] && [[ "$(readlink "$DST_FILE")" = "$SRC_FILE" ]]; then
    echo "unchanged"
  elif [[ "$OVERWRITE" -eq 1 ]]; then
    ln -fs "$SRC_FILE" "$DST_FILE"
    echo "replaced"
  elif [[ ! -e "$DST_FILE" ]]; then
    mkdir -p "$(dirname $DST_FILE)"
    ln -s "$SRC_FILE" "$DST_FILE"
    echo "created"
  else
    echo "not replacing"
    return 1
  fi
}
export -f linkfile
find "$SRC_DIR" -type f -print0 | xargs -n1 -0 bash -c 'linkfile "$@"' -- || true

RUN_SUDO=${RUN_SUDO:-}
if [ "$RUN_SUDO" = "1" ]; then
  export SRC_DIR="$(realpath etc)"
  function sudocopyfile {
    SRC_FILE="$1"
    REL_NAME="$(realpath --relative-to="$SRC_DIR" "$SRC_FILE")"
    DST_FILE="/etc/$REL_NAME"

    echo -n "$DST_FILE... "
    
    if [ -f "$DST_FILE" ]; then
      if sudo diff "$SRC_FILE" "$DST_FILE" &> /dev/null; then
        echo "unchanged"
      elif [[ "$OVERWRITE" -eq 1 ]]; then
        sudo cp "$SRC_FILE" "$DST_FILE"
        echo "replaced"
      else
        echo "not replacing"
        return 1
      fi
    else
      sudo mkdir -p "$(dirname $DST_FILE)"
      sudo cp "$SRC_FILE" "$DST_FILE"
      echo "created"
    fi
  }
  export -f sudocopyfile
  find "$SRC_DIR" -type f -print0 | xargs -n1 -0 bash -c 'sudocopyfile "$@"' -- || true
fi
