return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    require 'config.which-key'
  end,
}
