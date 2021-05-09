local M = {}

function M.startup(use)
  use {
    'rmagatti/auto-session',
    config = function()
      require'auto-session'.setup {}
    end
  }
end

return M
