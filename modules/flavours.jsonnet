local checks = import 'lib/checks.libsonnet';
{
  local root = self,

  flavours+: {},

  checks+: [checks.commandExists('flavours')],

  topgrade+: {
    config+: {
      commands+: {
        'flavours update': 'flavours update all',
      },
    },
  },

  // TODO do this with files
  activation+: [
    'mkdir -p `dirname %s`' % conf.file
    for conf in std.objectValues(root.flavours)
  ],

  files+: {
    '~/.config/flavours/config.toml': std.manifestToml({
      shell: "bash -c '{}'",

      item: [
        root.flavours[name]
        for name in std.objectFields(root.flavours)
      ],
    }),
  },
}
