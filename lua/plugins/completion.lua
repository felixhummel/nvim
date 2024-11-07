-- note: if you use the cmp.config.sources() helper, then first completion with hits wins.
-- https://github.com/hrsh7th/nvim-cmp/blob/29fb4854573355792df9e156cb779f0d31308796/doc/cmp.txt#L648
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
    'dmitmel/cmp-cmdline-history',
  },
  config = function()
    local cmp = require('cmp')
    local default_config = require('cmp.config').get()
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

    -- Command line mappings are special, but share many of the default buffer mappings.
    -- For example, up/down should go through the history in command mode
    -- (instead of selecting from the completion menu).
    local shared_mappings = {
      ['<Tab>'] = map(tab_handler),
      ['<C-n>'] = map(cmp.mapping.select_next_item()),
      ['<C-p>'] = map(cmp.mapping.select_prev_item()),
      ['<C-b>'] = map(cmp.mapping.scroll_docs(-4)),
      ['<C-f>'] = map(cmp.mapping.scroll_docs(4)),
      -- https://www.reddit.com/r/neovim/comments/xrbdny/how_to_select_from_nvimcmp_only_after_having/
      ['<CR>'] = map(cmp.mapping.confirm({ select = false })),
      ['<C-Space>'] = map(cmp.mapping.complete({})),
    }

    local buffer_mappings = vim.tbl_extend('force', shared_mappings, {
      ['<Down>'] = map(cmp.mapping.select_next_item()),
      ['<Up>'] = map(cmp.mapping.select_prev_item()),
    })

    cmp.setup({
      formatting = {
        fields = default_config.formatting.fields,
        expandable_indicator = default_config.formatting.expandable_indicator,
        format = function(entry, vim_item)
          vim_item.menu = entry.source.name
          return vim_item
        end,
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'longest,menuone,noselect' },
      preselect = cmp.PreselectMode.None,

      mapping = cmp.mapping.preset.insert(buffer_mappings),
      sources = {
        {
          name = 'buffer',
          option = {
            -- complete all buffers
            -- https://github.com/hrsh7th/cmp-buffer#all-buffers
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end,
          },
        },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        {
          name = 'path',
          option = {
            trailing_slash = true,
          },
        },
      },
    })

    cmp.setup.cmdline(':', {
      -- matching = { disallow_symbol_nonprefix_matching = false },
      mapping = cmp.mapping.preset.cmdline(shared_mappings),
      sources = {
        {
          name = 'cmdline_history',
          max_item_count = 8,
        },
        {
          name = 'path',
          max_item_count = 3,
          option = {
            trailing_slash = true,
          },
        },
        {
          name = 'cmdline',
          option = {
            ignore_cmds = { 'Man', '!' },
            treat_trailing_slash = false,
          },
          max_item_count = 3,
        },
      },
    })

    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(shared_mappings),
      sources = {
        {
          name = 'buffer',
          max_item_count = 5,
        },
      },
    })

    -- <C-x><C-k> for dictionary completion
    local words_file = '/usr/share/dict/words'
    if vim.fn.filereadable(words_file) == 1 then
      require('cmp_dictionary').setup({
        paths = { words_file },
        exact_length = 2,
        first_case_insensitive = true,
        document = {
          enable = true,
          -- sudo apt install wordnet
          command = { 'wn', '${label}', '-over' },
        },
      })
    end
    vim.api.nvim_set_keymap(
      'i',
      '<C-x><C-k>',
      [[<Cmd>lua require'cmp'.complete({ config = { sources = { { name = 'dictionary' } } } })<CR>]],
      { desc = 'complete from dictionary', noremap = true, silent = true }
    )
  end,
}
