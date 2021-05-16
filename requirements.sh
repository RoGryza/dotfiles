#!/bin/bash

set -euo pipefail

echo -n "Checking requirements... "

ERRORS=()

REQUIRED_CMDS=(bat direnv fd fzf i3 lsd git nvim rg tmux xclip zsh zoxide)

if uname -a | grep archlinux &> /dev/null; then
  REQUIRED_CMDS+=(yay pkgfile)
fi

# TODO move to modules
for CMD in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$CMD" &> /dev/null; then
    ERRORS+=("'$CMD' not found in \$PATH")
  fi
done

if [ ${#ERRORS[@]} -ne 0 ]; then
  echo
  for ERR in "${ERRORS[@]}"; do
    >&2 echo "$ERR"
  done
  exit 1
fi

echo "OK"
