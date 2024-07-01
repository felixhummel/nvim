# Lazy Config

## opts, config, init
```
:h lazy.nvim-lazy.nvim-plugin-spec
```

Use `opts` for simple overrides.
Use config to do sophisticated stuff. Note that config takes `opts` as second argument.
The default implementation looks something like this:
```lua
{
  'my-plugin',
  opts = {
    foo = 'bar',
  },
  config = function(_, opts)
    require('my-plugin').setup(opts)
  end,
}
```

Use `init` to do stuff on startup (e.g. plugins/notify.lua).


# nvim-cmp Tab Handler
```lua
-- generalized Tab handler
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#confirm-candidate-on-tab-immediately-when-theres-only-one-completion-entry
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
local tab_handler = function(fallback)
  if cmp.visible() then
    if #cmp.get_entries() == 1 then
      cmp.confirm({ select = true })
    end
    -- do not rotate through completions; do nothing instead
  elseif has_words_before() then
    cmp.complete()
    if #cmp.get_entries() == 1 then
      cmp.confirm({ select = true })
    end
  else
    fallback()
  end
end
```
