local checks = import 'lib/checks.libsonnet';
local util = import 'lib/util.libsonnet';
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

  files+: {
    '~/.config/flavours/config.toml': std.manifestToml({
      shell: "bash -c '{}'",

      item: [
        root.flavours[name]
        for name in std.objectFields(root.flavours)
      ],
    }),
  } + {
    [util.pathDirname(conf.file)]: { type: 'dir' }
    for conf in std.objectValues(root.flavours)
    if util.pathDirname(conf.file) != '~'
  },
}
