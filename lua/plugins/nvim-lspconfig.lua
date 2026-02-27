return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
    'williamboman/mason-lspconfig.nvim',
    'zapling/mason-lock.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      dependencies = {
        { 'gonstoll/wezterm-types', lazy = true },
      },
      opts = {
        library = {
          { path = 'wezterm-types', mods = { 'wezterm' } },
        },
      },
    },
  },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    -- :help lsp-vs-treesitter

    -- when an LSP attaches to a particular buffer:
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
        map('<leader>cd', require('telescope.builtin').lsp_references, 'Definition')
        map([[\v]], require('telescope.builtin').lsp_definitions, 'Goto Vsplit Definition')

        -- Find references for the word under your cursor.
        map('gr', require('telescope.builtin').lsp_references, 'Goto References')
        map('<leader>cu', require('telescope.builtin').lsp_references, 'Usages')
        map('<M-&>', require('telescope.builtin').lsp_references, 'Usages')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
        map('<M-Enter>', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        map('<leader>vD', function()
          vim.diagnostic.enable(false)
        end, 'Disable diagnostics', { 'n', 'x' })

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- The following autocommand is used to enable inlay hints in your
        -- code, if the language server you are using supports them
        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, 'Toggle Inlay Hints')
        end
      end,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
    -- local capabilities = {}
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      basedpyright = {},
      -- This language service will emit VS Code-specific telemetry events. If using the service outside of VS Code (e.g. in Vim), these telemetry events can be safely ignored.
      -- https://github.com/microsoft/compose-language-service#telemetry
      -- The following must be set for docker compose files: filetype=yaml.docker-compose
      docker_compose_language_service = {},
      -- `:help lspconfig-all` for a list of all the pre-configured LSPs
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
      ts_ls = {},
      vue_ls = {
        enabled = false,
      },
    }

    -- :Mason
    require('mason').setup()

    -- :MasonLock
    -- :MasonLockRestore
    require('mason-lock').setup({
      lockfile_path = vim.fn.stdpath('config') .. '/mason-lock.json', -- (default)
    })

    require('mason-lspconfig').setup({
      ensure_installed = {}, -- I use :MasonLock to install servers
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    })

    vim.lsp.config['helm_ls'] = {
      settings = {
        ['helm-ls'] = {
          yamlls = {
            path = 'yaml-language-server',
          },
        },
      },
    }
    vim.lsp.enable('helm_ls')

    vim.lsp.enable('dprint')
    vim.lsp.enable('gleam')

    -- :MasonInstall vue-language-server
    -- https://github.com/vuejs/language-tools/wiki/Neovim
    local vue_language_server_path = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server'
    local registry = require('mason-registry')
    local ok, pkg = pcall(registry.get_package, 'vue-language-server')
    if ok and pkg:is_installed() then
      local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }
      local vue_plugin = {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
        configNamespace = 'typescript',
      }
      local ts_ls_config = {
        init_options = {
          plugins = {
            vue_plugin,
          },
        },
        filetypes = tsserver_filetypes,
      }
      local vue_ls_config = {}
      vim.lsp.config('vue_ls', vue_ls_config)
      vim.lsp.config('ts_ls', ts_ls_config)
      vim.lsp.enable({ 'ts_ls', 'vue_ls' }) -- If using `ts_ls` replace `vtsls` to `ts_ls`
    else
      vim.lsp.enable('ts_ls')
    end

    -- use bun instead of node to run lsps
    -- https://github.com/mason-org/mason.nvim/discussions/1031
    local util = require('lspconfig.util')

    local function prefix_bun(cmd)
      return vim.list_extend({
        'bun',
        'run',
        '--bun',
      }, cmd)
    end

    util.on_setup = util.add_hook_before(util.on_setup, function(config, user_config)
      if config.cmd and is_node_server(config.name) then
        config.cmd = prefix_bun(config.cmd)
      end
    end)
  end,
}
