local extraModules = [
  import './delta.jsonnet',
];
local checks = import 'lib/checks.libsonnet';
local util = import 'lib/util.libsonnet';
local defaultModule = {
  checks+: [
    checks.commandExists('git'),
  ],

  git+: {
    config+: {
      user+: {
        name: error 'git.config.user.name must be set',
        email: error 'git.config.user.email must be set',
      },
      init+: {
        defaultBranch: 'master',
      },
      core+: {
        hooksPath: '~/.config/git/hooks',
      },
      credential+: {
        helper: 'store',
      },
      diff+: {
        colorMoved: 'default',
      },
      pull+: {
        rebase: false,
      },
    },
    hooks+: {
      'pre-push'+: {
        'protect-master': importstr './pre-push-protect-master.sh',
      },
    },
  },

  files+: {
    '~/.config/git/config': util.manifestGitConfig($.git.config),
  } + util.mergeAll(std.flatMap(
    function(hook)
      [{
        ['~/.config/git/hooks/' + hook]: {
          mode: '755',
          content: |||
            #!/bin/sh

            tmpfile=$(mktemp hookXXXXXX)
            trap "rm -f $tmpfile" EXIT
            cat > $tmpfile

            for SCRIPT in ~/.config/git/hooks/%s.d/*; do
              $SCRIPT "$@" < $tmpfile
            done
          ||| % [hook],
        },
      }] + [
        {
          ['~/.config/git/hooks/%s.d/%s' % [hook, hookScript]]: {
            mode: '755',
            content: $.git.hooks[hook][hookScript],
          },
        }
        for hookScript in std.objectFields($.git.hooks[hook])
      ],
    std.objectFields($.git.hooks)
  )),
};
util.mergeAll([defaultModule] + extraModules)
