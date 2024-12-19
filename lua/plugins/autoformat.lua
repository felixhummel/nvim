return {
  'stevearc/conform.nvim',
  lazy = false,
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<M-S-l>', -- muscle memory (pycharm)
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- disable docker-compose.yml auto format
      local bufname = vim.api.nvim_buf_get_name(0)
      local pattern = vim.glob.to_lpeg('docker-compose*.y*ml')
      if pattern:match(bufname) then
        return nil
      end
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
    formatters_by_ft = {
      lua = { 'stylua' },
      sql = { 'sleek' },
      python = { 'ruff_format' },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      terraform = { 'tofu_fmt' },
      caddyfile = { 'caddy_fmt' },
    },
    formatters = {
      caddy_fmt = {
        command = 'caddy',
        args = { 'fmt', '$FILENAME' },
      },
      sleek = {
        command = 'sleek',
        args = '--indent-spaces=2 --lines-between-queries=3',
      },
      sqlfluff = {
        args = { 'format', '--dialect=duckdb', '-' },
      },
    },
  },
}
