local checks = import 'lib/checks.libsonnet';
{
  checks+: [
    checks.commandExists('tmux'),
  ],

  repos+: {
    '~/.tmux/plugins/tpm': 'https://github.com/tmux-plugins/tpm',
  },

  files+: {
    '~/.tmux.conf': importstr './tmux.conf',
  },
}
