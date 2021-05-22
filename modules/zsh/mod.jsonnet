local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  checks+: [checks.commandExists('zsh')],

  profile+: {
    PATH: '$HOME/.local/bin:$PATH',
  },

  repos+: {
    '~/.local/lib/zsh/antigen': 'https://github.com/zsh-users/antigen.git',
  },

  topgrade+: {
    config+: {
      commands+: {
        'update antigen': 'source ~/.local/lib/zsh/antigen/antigen.zsh && antigen update',
      },
    },
  },

  files+: {
    '~/.zshrc': importstr './zshrc',
    '~/.zprofile': std.join('\n', [
      'export %s="%s"' % [var, root.profile[var]]
      for var in std.objectFields(root.profile)
    ]),
    '~/.local/lib/zsh/keyboard.sh': importstr './keyboard.sh',
  },
}
