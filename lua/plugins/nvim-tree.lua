return { -- nerdtree alternative
  'nvim-tree/nvim-tree.lua',
  config = function()
    local nvim_tree_lib = require 'nvim-tree.lib'
    local telescope = require 'telescope.builtin'
    local node = nvim_tree_lib.get_node_at_cursor()
    local api = require 'nvim-tree.api'
    -- TODO
    -- vim.keymap.set('n', '<F10>', api.open, { desc = 'open nvim-tree' })
    -- custom mappings as described here:
    -- https://github.com/nvim-tree/nvim-tree.lua/blob/8b2c5c678be4b49dff6a2df794877000113fd77b/README.md#custom-mappings
    local function my_on_attach(bufnr)
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- https://github.com/alexander-born/.cfg/blob/aa6475fd2b696ea07209e68a6db068cacff8e205/nvim/.config/nvim/lua/config/nvimtree.lua

      local function grep_at_current_tree_node()
        if not node then
          return
        end
        telescope.live_grep { search_dirs = { node.absolute_path } }
      end
      -- custom mappings
      vim.keymap.set('n', '<C-f>', grep_at_current_tree_node, opts 'find here')
    end
    require('nvim-tree').setup {
      on_attach = my_on_attach,
    }
  end,
}
