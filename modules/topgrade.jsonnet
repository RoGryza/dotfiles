local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  checks+: [checks.commandExists('topgrade')],

  repos+: {},

  topgrade+: {
    config+: {
      assume_yes: true,
      no_retry: true,
      git+: {
        repos+: std.objectValues(root.repos),
      },
    },
  },

  files+: {
    '~/.config/topgrade.toml': std.manifestToml(root.topgrade.config),
  },
}
