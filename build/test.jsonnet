// Quick n dirty jsonnet testing: jsonnet test.jsonnet
local util = import 'lib/util.libsonnet';
local tests = {
  testPathDirnameAbs: std.assertEqual(util.pathDirname('a/b'), 'a'),
  testPathDirnameRel: std.assertEqual(util.pathDirname('/a/b/c'), '/a/b'),
  testPathDirnameAbsDir: std.assertEqual(util.pathDirname('a/b/'), 'a'),
  testPathDirnameRelDir: std.assertEqual(util.pathDirname('/a/b/c/'), '/a/b'),

  testMapToArrayEmpty: std.assertEqual(util.mapToArray(id, {}), []),
  testMapToArrayNonEmpty: std.assertEqual(
    std.sort(
      util.mapToArray(function(k, v) [k, v], { a: 1, b: 2, c: 3 }),
      function(kv) kv[0],
    ),
    [['a', 1], ['b', 2], ['c', 3]],
  ),

  testArrayToObjEmpty: std.assertEqual(util.arrayToObj([]), {}),
  testArrayToObjNonEmpty: std.assertEqual(
    util.arrayToObj([['a', 1], ['b', 2], ['c', 3], ['a', 4]]),
    { a: 4, b: 2, c: 3 },
  ),

  testMapObjEmpty: std.assertEqual(util.mapObj(id, {}), {}),
  testMapObjNonEmpty: std.assertEqual(
    util.mapObj(function(k, v) [v, k], { a: '1', b: '2', c: '3' }),
    { '1': 'a', '2': 'b', '3': 'c' },
  ),
};

std.foldl(
  function(a, b) a && b,
  std.objectValues(tests),
  true,
)
