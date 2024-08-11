return {
  'hrsh7th/nvim-cmp',
  -- always :>
  -- event = 'InsertEnter',
  dependencies = {
    {
      'L3MON4D3/LuaSnip',
      build = 'make install_jsregexp',
      config = function()
        require('luasnip.loaders.from_snipmate').lazy_load()
      end,
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
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    luasnip.config.setup({})

    local tab_handler = function(fallback)
      if cmp.visible() then
        -- expand snippet
        if luasnip.expandable() then
          luasnip.expand()
        else
          -- bash-like behavior; see :h cmp.complete_common_string
          cmp.complete_common_string()
        end
        -- no completions? jump to next snippet location
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end
    -- map all modes (insert, select, command), so we can use the mappings in all completion setups
    local map = function(callable)
      return cmp.mapping(callable, { 'i', 's', 'c' })
    end

    local my_mappings = {
      ['<Tab>'] = map(tab_handler),
      ['<C-n>'] = map(cmp.mapping.select_next_item()),
      ['<Down>'] = map(cmp.mapping.select_next_item()),
      ['<C-p>'] = map(cmp.mapping.select_prev_item()),
      ['<Up>'] = map(cmp.mapping.select_next_item()),
      ['<C-b>'] = map(cmp.mapping.scroll_docs(-4)),
      ['<C-f>'] = map(cmp.mapping.scroll_docs(4)),
      -- https://www.reddit.com/r/neovim/comments/xrbdny/how_to_select_from_nvimcmp_only_after_having/
      ['<CR>'] = map(cmp.mapping.confirm({ select = false })),
      ['<C-Space>'] = map(cmp.mapping.complete({})),
    }

    local path_source_with_trailing_slash = {
      name = 'path',
      option = {
        trailing_slash = true,
      },
    }

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'longest,menuone,noselect' },
      preselect = cmp.PreselectMode.None,

      mapping = cmp.mapping.preset.insert(my_mappings),
      sources = {
        { name = 'buffer' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        path_source_with_trailing_slash,
      },
    })

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(my_mappings),
      sources = {
        { name = 'buffer' },
      },
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(my_mappings),
      sources = cmp.config.sources({
        path_source_with_trailing_slash,
      }, {
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
            treat_trailing_slash = false,
          },
        },
      }),
    })

    -- <C-x><C-k> for dictionary completion
    require('cmp_dictionary').setup({
      paths = { '/usr/share/dict/words' },
      exact_length = 2,
      first_case_insensitive = true,
      document = {
        enable = true,
        -- sudo apt install wordnet
        command = { 'wn', '${label}', '-over' },
      },
    })
    vim.api.nvim_set_keymap(
      'i',
      '<C-x><C-k>',
      [[<Cmd>lua require'cmp'.complete({ config = { sources = { { name = 'dictionary' } } } })<CR>]],
      { desc = 'complete from dictionary', noremap = true, silent = true }
    )
  end,
}
