{
  vim+: {
    plugins+: {
      'neoclide/coc-tsserver': {
        plug: { do: 'yarn install --frozen-lockfile' },
        config: |||
          augroup MyLangTs
            autocmd!
            autocmd BufWritePre *.ts :silent call CocAction('runCommand', 'editor.action.organizeImport')
          augroup END
        |||,
      },
    },
    coc+: {
      settings+: {
        'coc.preferences.formatOnSaveFiletypes'+: ['typescript'],
      },
    },
  },
}
