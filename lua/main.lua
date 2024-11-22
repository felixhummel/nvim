-- vim: ts=2 sts=2 sw=2 et
-- based on https://github.com/nvim-lua/kickstart.nvim

-- keep block cursor in insert mode
vim.opt.guicursor = ''

-- only complete things you are certain about, e.g.
-- `:e ~/.c<TAB>` remains at ~/.c and shows preview with ~/.cache, ~/.config, ...
-- https://www.reddit.com/r/neovim/comments/10rsl92/comment/j6xc38q/
vim.opt.wildmode = 'longest:full'

-- see plugins/completion.lua too
vim.opt.completeopt = 'longest,menuone,noselect'
vim.opt.mouse = '' -- disable mouse

vim.opt.laststatus = 2
vim.opt.tabpagemax = 50
vim.opt.iskeyword:append('-')

vim.cmd([[
set iskeyword+=-
set undofile
set undodir=~/.vim/undodir
set complete=.,w,b,u,t
set noswapfile  " disable swapfiles

autocmd BufWritePost ~/LOG/*.md silent execute '!cd $(dirname %) && git status -s >/dev/null && git add $(basename %) && git commit -qm log -- $(basename %) >/dev/null'

" https://vim.fandom.com/wiki/Dictionary_completions
set dictionary+=/usr/share/dict/words

" spellcheck (since neovim 0.9)
set spelllang=de_de,en_us
set spellcapcheck=
]])

vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'
require('bindings')

-- nvim-tree wants us to disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

-- Explicitly set Python. This resulted in a speedup from 6000ms to 1ms for finding Python in my setup. Could be due to pyenv and many interpreters on my machine.
-- Thanks to https://www.reddit.com/r/neovim/comments/ksf0i4/comment/giigobp/
local python_felix = vim.fn.expand('~/.pyenv/versions/felix/bin/python')
if vim.fn.filereadable(python_felix) == 1 then
  vim.g.python3_host_prog = python_felix
end

vim.opt.number = false

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

require('autocommands')
require('_lazy_install')

-- https://lazy.folke.io/installation
-- https://lazy.folke.io/usage/structuring
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

require('config.set-filetypes')

-- load old-school vim scripts
local old_school_vim_scripts_glob = vim.fn.stdpath('config') .. '/vimscripts/*.vim'
local old_school_vim_scripts = vim.fn.glob(old_school_vim_scripts_glob, true, true)
for _, file in ipairs(old_school_vim_scripts) do
  vim.cmd('source ' .. file)
end

-- enable fuzzy completion for nvim 0.11
-- https://www.reddit.com/r/neovim/comments/1fad1hm/comment/llscn3q/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
if vim.fn.has('nvim-0.11') == 1 then
  vim.opt.completeopt:append('fuzzy')
end
