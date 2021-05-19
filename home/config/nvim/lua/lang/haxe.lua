return {
  fts = {'hx', 'haxe'},
  plugins = {'jdonaldson/haxe'},
  lsp_servers = {
    haxe_language_server = {
      cmd = {'haxe-language-server'},
      filetypes = {'hx', 'haxe'},
      init_options = {
        displayArguments = { "compile.hxml" }
      }
    },
  },
}
