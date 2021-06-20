local checks = import 'lib/checks.libsonnet';
{
  checks+: [
    checks.commandExists('pass'),
    // TODO conditional dependency
    checks.commandExists('fzf'),
  ],

  files+: {
    '~/.local/bin/fpass': {
      mode: '755',
      content: |||
        #!/bin/sh
        cd "$HOME/.password-store"
        tree -Ffi | grep .gpg | sed 's/.gpg$//g' | sed 's/^..//' | fzf
      |||,
    },
  },
}
