{
  local root = self,

  nerdFonts+: {
    fonts: ['FiraCode'],
    version: '2.1.0',
  },

  // TODO need a better abstraction for the cache, also need to trigger onChange once no matter how
  // many fonts change.
  files+: {
    ['~.cache/nerdfonts/%s.zip' % font]: {
      type: 'http',
      content: 'https://github.com/ryanoasis/nerd-fonts/releases/download/v%s/%s.zip' % [root.nerdFonts.version, font],
      onChange: 'fc-cache -fv',
    }
    for font in root.nerdFonts.fonts
  },
}
