local checks = import 'lib/checks.libsonnet';
local util = import 'lib/util.libsonnet';
local defaultModule = {
  checks+: [checks.commandExists('jsonnet')],
};

local normalizeFile = function(value)
  if std.isString(value)
  then { type: 'file', mode: '644', content: value }
  else
    { type: 'file' } + value;

function(hostModule, modules)
  {
    local root = self,
    config: util.mergeAll([defaultModule] + modules + [hostModule]),
    output: {
      files: [
        { name: name } + normalizeFile(root.config.files[name])
        for name in std.objectFields(root.config.files)
      ],
    },
  }
