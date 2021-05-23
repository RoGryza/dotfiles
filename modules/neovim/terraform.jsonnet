local checks = import 'lib/checks.libsonnet';
{
  checks+: [checks.commandExists('terraform-lsp')],
  vim+: {
    plugins+: {
      'hashivim/vim-terraform': {
        config: |||
          let g:terraform_fmt_on_save=1

          augroup terraform
            autocmd!
            autocmd BufRead,BufNewFile *.hcl set filetype=terraform
          augroup END
        |||,
      },
    },

    coc+: {
      settings+: {
        languageserver: {
          terraform: {
            command: 'terraform-lsp',
            filetypes: [
              'terraform',
              'tf',
            ],
            initializationOptions: {},
            settings: {},
          },
        },
      },
    },
  },
}
