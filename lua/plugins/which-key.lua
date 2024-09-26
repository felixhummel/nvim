return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    local which_key = require('which-key')
    which_key.setup()

    -- normal
    which_key.add({
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>h', group = '[H]elp' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>w', group = '[W]orkspace' },
    })

    -- visual
    which_key.add({
      '<leader>h',
      desc = 'Git [H]unk',
      mode = 'v',
    })
  end,
}
