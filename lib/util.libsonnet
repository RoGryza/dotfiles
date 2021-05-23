{
  mergeAll:: function(arr) std.foldl(function(a, b) a + b, arr, {}),

  manifestGitConfig:: function(tbl)
    std.join('\n', std.flatMap(
      function(entry)
        ['[%s]' % entry] + [
          '\t%s = %s' % [item, tbl[entry][item]]
          for item in std.objectFields(tbl[entry])
        ],
      std.objectFields(tbl),
    )),

  _vimSerializers:: {
    string: std.escapeStringBash,
    object: function(value)
      local fields = $.mapToArray(
        function(k, v) '%s: %s' % [std.escapeStringBash(k), $.serializeVim(v)],
        value,
      );
      '{' + std.join(', ', fields) + '}',
  },
  serializeVim: function(value)
    local type = std.type(value);
    if std.objectHas($._vimSerializers, type)
    then $._vimSerializers[type](value)
    else error ("Can't serialize '%s' of type %s for vim" % [value, type]),

  pathDirname:: function(str)
    local parts = std.split(str, '/');
    local offset = if std.endsWith(str, '/') then 2 else 1;
    std.join('/', parts[:std.length(parts) - offset]),

  mapToArray:: function(fn, obj)
    std.map(function(k) fn(k, obj[k]), std.objectFields(obj)),

  arrayToObj:: function(arr) { [kv[0]]: kv[1] for kv in arr },

  mapObj:: function(fn, obj) $.arrayToObj($.mapToArray(fn, obj)),
  filterMapObj:: function(fn, obj) $.arrayToObj(std.prune($.mapToArray(fn, obj))),
}
