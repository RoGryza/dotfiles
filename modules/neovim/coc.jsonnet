local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  vim+: {
    plugins+: {
      'neoclide/coc.nvim': {
        branch: 'release',
        config: importstr './coc.vim',
      },
    },
    coc+: {
      settings+: {},
    },
  },

  files+: {
    '~/.config/nvim/coc-settings.json': std.manifestJson(root.vim.coc.settings),
  },
}
