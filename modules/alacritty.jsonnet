local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  checks+: [
    checks.commandExists('alacritty'),
  ],

  flavours+: {
    alacritty: {
      file: '~/.config/alacritty/alacritty.yml',
      template: 'alacritty',
      subtemplate: 'default-256',
      rewrite: true,
    },
  },
}
