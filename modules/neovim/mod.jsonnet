local checks = import 'lib/checks.libsonnet';
local util = import 'lib/util.libsonnet';
local extraModules = [
  import './coc.jsonnet',
  // import './langs/zig.jsonnet',
  import './langs/typescript.jsonnet',
  import './langs/rust.jsonnet',
  import './langs/toml.jsonnet',
];
local defaultModule = {
  checks+: [
    checks.commandExists('nvim'),
    checks.commandExists('nvr'),
  ],

  profile+: {
    NVIM_LISTEN_ADDRESS: '/tmp/nvimsocket',
    EDITOR: 'nvim',
    VISUAL: 'nvim',
    SUDO_EDITOR: 'nvim',
  },

  vim+: {
    plugins+: {
      'tpope/vim-commentary': {},
      'tpope/vim-eunuch': {},
      'tpope/vim-repeat': {},
      'tpope/vim-surround': {},
      'tpope/vim-fugitive': {},
      'junegunn/fzf.vim': {
        config: |||
          nnoremap <silent> <C-p> <Cmd>Files<CR>
          nnoremap <silent> <C-b> <Cmd>Buffers<CR>
        |||,
      },
      'google/vim-jsonnet': {},
    },
  },

  files+: {
    '~/.config/nvim/init.vim': (importstr './init.vim') + '\npackadd my-plugins',
    '~/.local/lib/flavour/nvim.sh': importstr './flavours-hook.sh',
    '~/.local/share/nvim/site/pack/my/opt/my-plugins/plugin/init.vim': std.join(
      '\n',
      ['call plug#begin(stdpath("data") . "/plugged")\n']
      + util.mapToArray(
        function(plugin, config)
          'Plug %s%s' % [
            std.escapeStringBash(plugin),
            if std.objectHas(config, 'plug')
            then ', %s' % util.serializeVim(config.plug)
            else '',
          ],
        $.vim.plugins,
      )
      + ['\ncall plug#end()']
      + [
        '\n" %s\n%s' % [plugin, $.vim.plugins[plugin].config]
        for plugin in std.objectFields($.vim.plugins)
        if std.objectHas($.vim.plugins[plugin], 'config')
      ]
    ),
    // TODO maybe use git instead of curl
    '~/.local/share/nvim/site/autoload/plug.vim': {
      type: 'http',
      content: 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
    },
  },

  flavours+: {
    vim: {
      file: '~/.config/nvim/colors/base16.vim',
      template: 'vim',
      rewrite: true,
      hook: '~/.local/lib/flavour/nvim.sh',
    },
  },
};
util.mergeAll([defaultModule] + extraModules)
