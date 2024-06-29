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
vim.opt.iskeyword:append '-'

vim.cmd [[
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
]]

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
  require 'plugins.oil',
  { 'declancm/maximize.nvim', config = true },
  require 'plugins.clipboard-images',
  -- ausprobieren
  -- https://github.com/AckslD/nvim-neoclip.lua?tab=readme-ov-file
}
local _lazy_config = require 'config.lazy'
require('lazy').setup(_lazy_setup, _lazy_config)

local function set_filetype(pattern, filetype)
  vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = pattern,
    command = 'set filetype=' .. filetype,
  })
end

set_filetype({ 'docker-compose*.yml' }, 'yaml.docker-compose')
