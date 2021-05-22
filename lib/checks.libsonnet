{
  commandExists:: function(cmd) |||
    CMD=%s
    if ! command -v "$CMD" &> /dev/null; then
      check_add_error "Required command '$CMD' not found in \$PATH."
    fi
  ||| % [std.escapeStringBash(cmd)],
}
