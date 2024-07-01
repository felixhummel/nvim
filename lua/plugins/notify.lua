return {
  'rcarriga/nvim-notify',
  opts = {
    stages = 'static',
  },
  init = function(_)
    vim.notify = require('notify')
  end,
}
