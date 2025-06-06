return {
  'lewis6991/gitsigns.nvim',
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require('gitsigns')

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          gitsigns.nav_hunk('next')
        end
      end, { desc = 'Jump to next git [c]hange' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          gitsigns.nav_hunk('prev')
        end
      end, { desc = 'Jump to previous git [c]hange' })

      -- Actions
      -- Borrowed from https://github.com/exosyphon/nvim/blob/main/lua/plugins.lua
      -- visual mode
      map('v', '<leader>hs', function()
        gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'stage git hunk' })
      map('v', '<leader>hr', function()
        gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, { desc = 'reset git hunk' })
      -- normal mode
      map('n', '<leader>ga', gitsigns.blame, { desc = 'annotate (blame)' })
      map('n', '<leader>gb', gitsigns.blame_line, { desc = 'blame line' })
      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'stage hunk' })
      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'reset hunk' })
      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
      map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'undo stage hunk' })
      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'preview hunk' })
      map('n', '<leader>gd', gitsigns.diffthis, { desc = 'diff against index' })
      map('n', '<leader>gD', function()
        gitsigns.diffthis('@')
      end, { desc = 'git [D]iff against last commit' })
      -- Toggles
      map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle show blame line' })
      map('n', '<leader>gtD', gitsigns.toggle_deleted, { desc = 'Toggle show Deleted' })
    end,
  },
}
