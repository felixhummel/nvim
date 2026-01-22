local repo_dir = vim.fn.expand('~/hacks/llm.nvim')
return {
  {
    enabled = function()
      return vim.uv.fs_stat(repo_dir) ~= nil
    end,
    dir = repo_dir,
    name = 'llm.nvim',
    config = function()
      require('llm')
    end,
  },
}
