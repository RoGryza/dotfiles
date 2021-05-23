local checks = import 'lib/checks.libsonnet';
{
  vim+: {
    plugins+: {
      'neoclide/coc.nvim': {
        plug: { branch: 'release' },
        config: importstr './coc.vim',
      },
    },
    coc+: {
      settings+: {},
    },
  },

  files+: {
    '~/.config/nvim/coc-settings.json': std.manifestJson($.vim.coc.settings),
  },
}
