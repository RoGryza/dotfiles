{
  vim+: {
    plugins+: {
      'fannheyward/coc-rust-analyzer': { plug: { do: 'yarn install --frozen-lockfile' } },
    },
    coc+: {
      settings+: {
        'rust-analyzer.server.path': '/usr/bin/rust-analyzer',
      },
    },
  },
}
