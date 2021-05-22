local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  checks+: [
    checks.commandExists('gpg'),
  ],

  files+: {
    '~/.gnupg': {
      mode: '700',
      type: 'dir',
    },
    '~/.gnupg/gpg-agent.conf': {
      mode: '600',
      content: 'pinentry-program /usr/bin/pinentry-qt',
    },
  },
}
