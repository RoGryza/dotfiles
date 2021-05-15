return {
  fts = {'typescript'},
  treesitter = true,
  plugins = {
    'jose-elias-alvarez/nvim-lsp-ts-utils',
    requires = 'nvim-lspconfig',
  },
  lsp_servers = {
    tsserver = {
      on_attach = function()
        require'nvim-lsp-ts-utils'.setup {
          enable_import_on_completion = true,
          import_on_completion_timeout = 5000,

          -- TODO
          -- eslint_enable_diagnostics = true,
          -- eslint_diagnostics_debounce = 250,

          enable_formatting = true,
          formatter = "prettier",
          formatter_args = {"--stdin-filepath", "$FILENAME"},
          format_on_save = true,
          no_save_after_format = false,
        }
        vim.cmd [[
        augroup lsp_document_formatting
          autocmd! * <buffer>
        augroup END
        ]]
      end
    },
  },
}
