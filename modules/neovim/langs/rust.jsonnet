{
  vim+: {
    plugins+: {
      'fannheyward/coc-rust-analyzer': {
        plug: { do: 'yarn install --frozen-lockfile' },
        config: |||
          augroup MyLangRust
            autocmd!
            autocmd BufWritePre *.rs :silent call CocAction('runCommand', 'editor.action.organizeImport')
          augroup END
        |||,
      },
    },
    coc+: {
      settings+: {
        'coc.preferences.formatOnSaveFiletypes'+: ['rust'],
        'rust-analyzer.server.path': '/usr/bin/rust-analyzer',
      },
    },
  },
}
