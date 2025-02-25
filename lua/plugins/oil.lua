return {
  'stevearc/oil.nvim',
  opts = {
    -- C-o https://github.com/stevearc/oil.nvim/issues/201
    cleanup_delay_ms = false,
    view_options = {
      show_hidden = true,
    },
    skip_confirm_for_simple_edits = true,
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
