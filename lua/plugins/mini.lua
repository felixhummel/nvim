return {
  'echasnovski/mini.nvim',
  config = function()
    -- :help MiniAi-textobject-builtin
    -- to list textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup({ n_lines = 500 })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    require('mini.completion').setup({
      -- don't mess with my 'shortmess' or 'completeopt'
      -- shortmess=CFToctlO
      set_vim_settings = true,
    })

    local statusline = require('mini.statusline')

    statusline.setup({
      use_icons = vim.g.have_nerd_font,
    })

    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_filename = function()
      if vim.bo.buftype == 'terminal' then
        return '%t'
      else
        -- MiniStatusline.section_filename uses fullpath if not truncated
        -- I always want the relative path.
        -- see also :help 'statusline' and search for "meaning"
        return '%f%m%r'
      end
    end
    -- set the section for cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    -- i'll leave statusline.section_git (showing branch / head ref) for now

    -- disable diff summary (too much noise for me)
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_diff = function() end
  end,
}
