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
}
