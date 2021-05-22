local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  checks+: [
    checks.commandExists('direnv'),
  ],

  files+: {
    '~/.config/direnv/direnvrc': importstr './direnvrc',
  },
}
