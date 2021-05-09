# Somewhat copied from ZSH setup script
# https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
ZSH="$HOME/.oh-my-zsh"
REMOTE="https://github.com/ohmyzsh/ohmyzsh.git"

if [ ! -d "$ZSH" ]; then
  umask g-w,o-w

  git clone -c core.eol=lf -c core.autocrlf=false \
      -c fsck.zeroPaddedFilemode=ignore \
      -c fetch.fsck.zeroPaddedFilemode=ignore \
      -c receive.fsck.zeroPaddedFilemode=ignore \
      --depth=1 "$REMOTE" "$ZSH" || {
        echo "git clone of oh-my-zsh repo failed"
        exit 1
      }
fi

plugins=(cargo colorize docker kubectl fasd pass git gpg-agent zsh_reload)
source "$ZSH/oh-my-zsh.sh"
