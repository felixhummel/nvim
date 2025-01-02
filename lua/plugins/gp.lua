return {
  {
    'robitx/gp.nvim',
    config = function()
      local conf = {
        openai_api_key = { 'hukudo-secret-get', 'hukudo/openai_api_key' },
      }
      require('gp').setup(conf)

      -- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
      vim.keymap.set({ 'n', 'v' }, '<leader>asd', '<cmd>GpWhisper de<CR>', { desc = 'GpWhisper de' })
      vim.keymap.set({ 'n', 'v' }, '<leader>ase', '<cmd>GpWhisper en<CR>', { desc = 'GpWhisper en' })
    end,
  },
}
