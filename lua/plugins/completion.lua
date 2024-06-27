return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    {
      'L3MON4D3/LuaSnip',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      config = function()
        require('luasnip.loaders.from_snipmate').lazy_load()
      end,
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
    },
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-emoji',
    'uga-rosa/cmp-dictionary',
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#confirm-candidate-on-tab-immediately-when-theres-only-one-completion-entry
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
    end

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'longest,menuone,noselect' },
      preselect = cmp.PreselectMode.None,

      mapping = cmp.mapping.preset.insert {
        -- bash-like
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm { select = true }
              -- do not rotate through completions; do nothing instead
              -- else
              --   cmp.select_next_item()
            end
          elseif has_words_before() then
            cmp.complete()
            if #cmp.get_entries() == 1 then
              cmp.confirm { select = true }
            end
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<Up>'] = cmp.mapping.select_next_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        -- https://www.reddit.com/r/neovim/comments/xrbdny/how_to_select_from_nvimcmp_only_after_having/
        ['<CR>'] = cmp.mapping.confirm { select = false },
        ['<C-Space>'] = cmp.mapping.complete {},
      },
      sources = {
        { name = 'buffer' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
          name = 'path',
          option = {
            trailing_slash = true,
          },
        },
      },
    }

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' },
      },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' },
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
            treat_trailing_slash = true,
          },
        },
      }),
    })

    -- <C-x><C-k> for dictionary completion
    require('cmp_dictionary').setup {
      paths = { '/usr/share/dict/words' },
      exact_length = 2,
      first_case_insensitive = true,
      document = {
        enable = true,
        -- sudo apt install wordnet
        command = { 'wn', '${label}', '-over' },
      },
    }
    vim.api.nvim_set_keymap(
      'i',
      '<C-x><C-k>',
      [[<Cmd>lua require'cmp'.complete({ config = { sources = { { name = 'dictionary' } } } })<CR>]],
      { desc = 'complete from dictionary', noremap = true, silent = true }
    )
  end,
}
