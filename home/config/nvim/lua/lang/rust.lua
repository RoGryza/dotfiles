return {
  fts = {'rust'},
  treesitter = true,
  plugins = {
    'simrat39/rust-tools.nvim',
    after = {'telescope.nvim'},
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require'rust-tools'.setup({})
    end
  },
  lsp_servers = {
    rust_analyzer = {},
  },
}
