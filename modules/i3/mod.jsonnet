local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  checks+: [checks.commandExists('i3')],

  files+: {
    '~/.config/i3/config': importstr './config',
  },
}
