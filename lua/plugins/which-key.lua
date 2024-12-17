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
      { '<leader>/', group = 'Search' },
      { '<leader>w', group = 'Workspace' },
      { '<leader>v', group = 'Vim' },
    })

    -- visual
    which_key.add({
      '<leader>h',
      desc = 'Git Hunk',
      mode = 'v',
    })
  end,
}
