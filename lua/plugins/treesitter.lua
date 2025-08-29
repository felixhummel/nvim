return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
        custom_captures = {
          ['function.diff'] = 'FelixDiffFileHighlight',
          ['variable.parameter.diff'] = 'FelixDiffFileHighlight',
        },
      },
      indent = {
        enable = true,
        -- https://www.reddit.com/r/neovim/comments/1agynre/how_to_make_markdown_list_items_indent_behind_the/
        disable = { 'ruby', 'markdown' },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ['ab'] = { query = '@block.outer', desc = 'block.outer' },
            ['ib'] = { query = '@block.inner', desc = 'block.inner' },
            ['af'] = { query = '@function.outer', desc = 'function.outer' },
            ['if'] = { query = '@function.inner', desc = 'function.inner' },
            ['ac'] = { query = '@class.outer', desc = 'class.outer' },
            ['ic'] = { query = '@class.inner', desc = 'class.inner' },
            ['at'] = { query = '@table_constructor.outer', desc = 'table_constructor.outer' },
            ['it'] = { query = '@table_constructor.inner', desc = 'table_constructor.inner' },
            ['as'] = { query = '@scope', query_group = 'locals', desc = 'Select language scope' },
          },
          selection_modes = {
            -- 'v' = charwise, 'V' = linewise, '<c-v>' = blockwise
            ['@parameter.outer'] = 'v',
            ['@block.outer'] = 'V',
            ['@block.inner'] = 'V',
            ['@function.outer'] = 'V',
            ['@function.inner'] = 'V',
            ['@class.outer'] = '<c-v>',
          },
        },
      },
    },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)

      -- git commit preview with higher visibility for files
      -- Use `:Inspect` to show node under cursor.
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'gitcommit',
        callback = function()
          -- Define the custom highlight group
          vim.api.nvim_set_hl(0, 'FelixDiffFileHighlight', {
            fg = '#000000',
            bg = '#FF00FF',
            bold = true,
          })
          vim.api.nvim_set_hl(0, '@function.diff', { link = 'FelixDiffFileHighlight' })
          vim.api.nvim_set_hl(0, '@variable.parameter.diff', { link = 'FelixDiffFileHighlight' })
          -- vim.api.nvim_set_hl(0, '@string.special.path.diff', { link = 'FelixDiffFileHighlight' })
        end,
      })
      -- maybe
      --
      -- - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      -- - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    end,
  },
}
