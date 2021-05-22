local checks = import 'lib/checks.libsonnet';
local util = import 'lib/util.libsonnet';
{
  local root = self,

  checks+: [
    checks.commandExists('git'),
  ],

  git+: {
    config+: {
      user: {
        name: error 'git.config.user.name must be set',
        email: error 'git.config.user.email must be set',
      },
      init: {
        defaultBranch: 'master',
      },
      core: {
        hooksPath: '~/.config/git/hooks',
      },
      credential: {
        helper: 'store',
      },
    },
    hooks+: {
      'pre-push'+: {
        'protect-master': importstr './pre-push-protect-master.sh',
      },
    },
  },

  files+: {
    '~/.config/git/config': util.manifestGitConfig(root.git.config),
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

            for SCRIPT in %s/git/hooks/%s.d/*; do
              $SCRIPT "$@" < $tmpfile
            done
          |||,
        },
      }] + [
        {
          ['~/.config/git/hooks/%s.d/%s' % [hook, hookScript]]: {
            mode: '755',
            content: root.git.hooks[hook][hookScript],
          },
        }
        for hookScript in std.objectFields(root.git.hooks[hook])
      ],
    std.objectFields(root.git.hooks)
  )),
}
