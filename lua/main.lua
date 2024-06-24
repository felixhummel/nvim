-- based on
-- https://github.com/nvim-lua/kickstart.nvim

-- complete only to certainty, e.g.
-- :e ~/.c<TAB> remains at ~/.c and shows preview with ~/.cache, ~/.config, ...
-- https://www.reddit.com/r/neovim/comments/10rsl92/comment/j6xc38q/
vim.opt.wildmode = 'longest:full'

-- used later to configure cmp too
local completeopt = 'longest,menuone,noselect'
vim.opt.completeopt = completeopt
vim.opt.mouse = '' -- disable mouse

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'bindings'
-- nvim-tree wants us to disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.have_nerd_font = true

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

require 'autocommands'
require '_lazy_install'

local _lazy_setup = {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  require 'plugins.comment',
  require 'plugins.which-key',
  require 'plugins.telescope',
  require 'plugins.nvim-lspconfig',
  require 'plugins.autoformat',
  require 'plugins.completion',
  require 'plugins.colorscheme',
  require 'plugins.mini',
  require 'plugins.treesitter',
  'mrcjkb/nvim-lastplace', -- remember cursor position
  'junegunn/fzf.vim', -- old-school fzf
  'https://gitlab.com/mcepl/vim-fzfspell/', -- spelling with fzf
  require 'plugins.nvim-tree',
  { 'declancm/maximize.nvim', config = true },
}
local _lazy_config = require 'config.lazy'
require('lazy').setup(_lazy_setup, _lazy_config)
-- vim: ts=2 sts=2 sw=2 et
