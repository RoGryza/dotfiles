#!/bin/bash
for SRV in "$(nvr --serverlist)"; do \
  nvr \
    --servername "$SRV" --nostart \
    --remote-send ":colorscheme base16<CR>" || true
done
