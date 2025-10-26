return {
  {
    'gruvw/strudel.nvim',
    build = 'pnpm install',
    config = function()
      require('strudel').setup()
    end,
  },
}
