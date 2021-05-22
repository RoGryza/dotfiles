local checks = import 'lib/checks.libsonnet';
{
  checks+: [checks.commandExists('xrdb')],

  files+: {
    '~/.xinitrc': {
      mode: '755',
      content: importstr './xinitrc',
    },
    '~/.xsession': { type: 'link', content: '~/.xinitrc' },
    '~/.config/x11/nvidia-xinitrc': { type: 'link', content: '~/.xinitrc' },
    '~/.xserverrc': {
      mode: '755',
      content: importstr './xserverrc',
    },
  },

  flavours+: {
    Xresources: {
      file: '~/.Xresources',
      template: 'xresources',
      rewrite: true,
      hook: 'xrdb -merge ~/.Xresources',
    },
  },
}
