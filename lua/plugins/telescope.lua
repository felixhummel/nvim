return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    { 'benfowler/telescope-luasnip.nvim' },
    'debugloop/telescope-undo.nvim',
  },
  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ['<C-f>'] = actions.to_fuzzy_refine,
            -- close telescope window on <ESC> (instead of going into normal mode)
            -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#mapping-esc-to-quit-in-insert-mode
            ['<Esc>'] = actions.close,
            -- clear current prompt
            ['<C-u>'] = false,
            ['<C-q>'] = actions.send_to_qflist,
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        undo = {
          -- https://github.com/debugloop/telescope-undo.nvim
        },
      },
    })
    -- note: pcall returns error code instead of propagating. In this case: ignore errors.
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'luasnip')
    pcall(require('telescope').load_extension, 'undo')

    ---@return string # Oil's current directory. Fall back to cwd.
    local function get_relevant_dir()
      local result = vim.fn.getcwd()
      local oil_dir = require('oil').get_current_dir()
      if type(oil_dir) == 'string' then
        result = oil_dir
      end
      return result
    end

    local builtin = require('telescope.builtin')

    local function map(mode, lhs, desc, rhs)
      vim.keymap.set(mode, lhs, rhs, { desc = desc })
    end
    local function nmap(lhs, desc, rhs)
      map('n', lhs, desc, rhs)
    end

    nmap('<leader><leader>', 'live_grep', builtin.live_grep)
    nmap('<leader>/h', 'help_tags', builtin.help_tags)
    nmap('<leader>/k', 'keymaps', builtin.keymaps)
    nmap('<leader>/f', 'find_files', builtin.find_files)
    nmap('<leader>/s', 'snippets', require('telescope').extensions.luasnip.luasnip)
    map({ 'n', 'v' }, '<leader>/w', 'grep_string', builtin.grep_string)
    nmap('<leader>/b', 'buffers', builtin.buffers)
    nmap('<leader>/d', 'diagnostics', builtin.diagnostics)
    nmap('<leader>//', 'resume last search', builtin.resume)
    nmap('<leader>/.', 'oldfiles', builtin.oldfiles)

    nmap('<leader>/g', 'Search / in Open Files', function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      })
    end)

    -- Shortcut for searching your Neovim configuration files
    nmap('<leader>/v', 'Search Neovim files', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end)

    local function _grep_or_resume(grep_opts)
      local cached_pickers = require('telescope.state').get_global_key('cached_pickers')
      if cached_pickers == nil or vim.tbl_isempty(cached_pickers) then
        builtin.live_grep(grep_opts)
      else
        builtin.resume()
      end
    end
    nmap('<C-f>', 'Find (grep)', function()
      _grep_or_resume({ search_dirs = { get_relevant_dir() } })
    end)
    -- use visual selection by yanking to register v
    map({ 'v' }, '<C-f>', 'Find (grep)', function()
      vim.cmd.normal('"vy')
      _grep_or_resume({
        default_text = vim.fn.getreg('v'),
        search_dirs = { get_relevant_dir() },
      })
    end)

    nmap('<C-g>', 'Find files', function()
      builtin.find_files({
        cwd = get_relevant_dir(),
        hidden = true,
      })
    end)
  end,
}
