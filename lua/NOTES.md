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


# nvim-cmp

## Tab Handler
This was the old one I used before finding the current one via `:help`.
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

## Completion Handling
As you start typing, nvim-cmp does a fuzzy search.

Maybe you forgot specific syntax, but you are looking for something with `cmp` and `mapping`.
Thus, you write `cmpmapp` and get a lot of information about that.

Other times, you know exactly what you are looking for, for example paths,
because you are used to Bash's completition. To go to a path
`plugins/notify.lua`, in bash you'd type `cd pl<Tab>no<Tab>`. That's exactly
what you can do here to: `:vs pl<Tab>no<Tab>`, even though you will see the
fuzzy completion for `plugins/nvim-lspconfig.lua` after having typed
`pl<Tab>no`.

Please note that you can select fuzzy-completion items using `<C-n>` and
`<C-p>`, if you want to use non-prefix based matching.

Isn't that beautiful? You get the best of both worlds: discoverability with
fuzzy search and precision with prefix-based completion. 🤓
