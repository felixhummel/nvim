return {
  {
    'robitx/gp.nvim',
    config = function()
      local conf = {
        openai_api_key = { 'hukudo-secret-get', 'hukudo/openai_api_key' },
      }
      require('gp').setup(conf)

      -- map lhs to cmd with desc = cmd
      local function map_cmd(lhs, cmd)
        vim.keymap.set({ 'n', 'v' }, lhs, '<cmd>' .. cmd .. '<CR>', { desc = cmd })
      end
      map_cmd('<leader>ac', 'GpChatPaste vsplit')
      map_cmd('<leader>asd', 'GpWhisper de')
      map_cmd('<leader>ase', 'GpWhisper en')
    end,
  },
}
