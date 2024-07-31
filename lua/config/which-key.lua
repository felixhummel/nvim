local which_key = require('which-key')
which_key.setup()

-- normal
which_key.add({
  { '<leader>c', group = '[C]ode' },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>h', group = 'Git [H]unk' },
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
