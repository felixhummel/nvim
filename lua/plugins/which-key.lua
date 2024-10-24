return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    local which_key = require('which-key')
    which_key.setup()

    -- normal
    which_key.add({
      { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
      { '<leader>d', group = 'Document' },
      { '<leader>h', group = 'Help' },
      { '<leader>r', group = 'Rename' },
      { '<leader>s', group = 'Search' },
      { '<leader>t', group = 'Toggle' },
      { '<leader>w', group = 'Workspace' },
    })

    -- visual
    which_key.add({
      '<leader>h',
      desc = 'Git Hunk',
      mode = 'v',
    })
  end,
}
