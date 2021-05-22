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
