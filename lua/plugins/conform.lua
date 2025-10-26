-- FormatEnable / FormatDisable from https://github.com/stevearc/conform.nvim/issues/192#issuecomment-2573170631
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
      '<M-L>', -- muscle memory (pycharm)
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<leader>vf',
      function()
        -- If autoformat is currently disabled for this buffer,
        -- then enable it, otherwise disable it
        if vim.b.disable_autoformat then
          vim.cmd('FormatEnable')
          vim.notify('Enabled autoformat for current buffer')
        else
          vim.cmd('FormatDisable!')
          vim.notify('Disabled autoformat for current buffer')
        end
      end,
      desc = 'Toggle autoformat for current buffer',
    },
    {
      '<leader>vF',
      function()
        -- If autoformat is currently disabled globally,
        -- then enable it globally, otherwise disable it globally
        if vim.g.disable_autoformat then
          vim.cmd('FormatEnable')
          vim.notify('Enabled autoformat globally')
        else
          vim.cmd('FormatDisable')
          vim.notify('Disabled autoformat globally')
        end
      end,
      desc = 'Toggle autoformat globally',
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- respect disable flag
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
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
      caddyfile = { 'caddy_fmt' },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      go = { 'gofmt' },
      hcl = { 'hcl' },
      lua = { 'stylua' },
      json = { 'deno_fmt' },
      python = { 'ruff_format' },
      sh = { 'shfmt' },
      -- sql = { 'sleek' },
      terraform = { 'tofu_fmt' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      typescriptreact = { 'prettierd' },
    },
    formatters = {
      caddy_fmt = {
        command = 'caddy',
        -- When false, will create a temp file (will appear in "$FILENAME" args). The temp
        -- file is assumed to be modified in-place by the format command.
        stdin = false,
        args = { 'fmt', '--overwrite', '$FILENAME' },
      },
      sleek = {
        command = 'sleek',
        args = '--indent-spaces=2 --lines-between-queries=3',
      },
      sqlfluff = {
        args = { 'format', '--dialect=duckdb', '-' },
      },
      -- https://github.com/mvdan/sh/blob/master/cmd/shfmt/shfmt.1.scd
      shfmt = {
        prepend_args = { '--space-redirects', '--indent', '2' },
      },
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)

    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- :FormatDisable! disables autoformat for this buffer only
        vim.b.disable_autoformat = true
      else
        -- :FormatDisable disables autoformat globally
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true, -- allows the ! variant
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Re-enable autoformat-on-save',
    })
  end,
}
