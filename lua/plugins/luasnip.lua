return {
  'L3MON4D3/LuaSnip',
  config = function()
    require('luasnip.loaders.from_snipmate').lazy_load()

    local luasnip = require('luasnip')
    -- I have no idea what I'm doing, but ChatGPT seems to...
    -- https://chatgpt.com/share/6751c42a-f9f0-8005-8e55-0c607df9e42b
    vim.keymap.set({ 'i' }, '<Tab>', function()
      if luasnip.expandable() then
        luasnip.expand()
      else
        return vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, true, true), 'n', true)
      end
    end, { silent = true })
  end,
}
