local checks = import 'lib/checks.libsonnet';
{
  local root = self,
  local themeName = 'my-base16',

  checks+: [
    checks.commandExists('bat'),
  ],

  files+: {
    '~/.config/bat/config': '--theme=' + themeName,
  },

  flavours+: {
    bat: {
      file: '~/.config/bat/themes/%s.tmTheme' % [themeName],
      template: 'textmate',
      rewrite: true,
      hook: 'bat cache --build',
    },
  },
}
