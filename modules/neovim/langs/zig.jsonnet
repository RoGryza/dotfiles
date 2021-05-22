local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  checks+: [
    checks.commandExists('zig'),
    checks.commandExists('zls'),
  ],

  vim+: {
    plugins+: {
      'ziglang/zig.vim': {},
    },

    coc+: {
      settings+: {
        languageserver: {
          zls: {
            command: 'zls',
            filetypes: ['zig'],
          },
        },
      },
    },
  },
}
