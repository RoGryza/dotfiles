local checks = import 'lib/checks.libsonnet';
local util = import 'lib/util.libsonnet';
local defaultModule = {
  checks+: [checks.commandExists('jsonnet')],
};

local normalizeFile = function(value)
  { type: 'file' } +
  if std.isString(value)
  then { content: value }
  else value;

local exportObj = function(type, obj)
  std.join(
    ' ',
    ['df_export_' + type]
    + util.mapToArray(
      function(k, v) '--%s=%s' % [k, std.escapeStringBash(std.toString(v))],
      obj,
    ),
  );

local exportChecks = function(checks) std.map(
  function(check) exportObj('check', check),
  checks,
);

local exportFiles = function(files) util.mapToArray(
  function(name, file) exportObj(
    'file',
    { name: name } +
    if file.type == 'file' || file.type == 'dir'
    then file { content:: null }
    else file
  ),
  files,
);

function(hostModule, modules)
  local config = util.mergeAll([defaultModule] + modules + [hostModule]);
  local normalizedFiles = std.mapWithKey(function(_, v) normalizeFile(v), config.files);
  util.filterMapObj(
    function(k, v) if v.type == 'file' then ['content/' + k, v.content],
    normalizedFiles,
  ) + {
    'exports.sh': std.join('\n', exportChecks(config.checks) + exportFiles(normalizedFiles)),
  }
