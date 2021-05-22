local checks = import 'lib/checks.libsonnet';
{
  checks+: [
    checks.commandExists('delta'),
  ],

  git+: {
    config+: {
      core+: {
        pager: 'delta',
      },
      interactive+: {
        diffFilter: 'delta --color-only',
      },
      delta+: {
        light: true,
        features: 'side-by-side line-numbers decorations',
      },
    },
  },
}
