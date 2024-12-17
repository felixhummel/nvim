vim.keymap.set('n', '<C-p>', '<cmd>FelixClip<CR>', { desc = 'paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<C-y>', '"+y', { desc = 'copy to system clipboard' })

vim.keymap.set('n', 'gF', ':vertical wincmd f<CR>', { desc = 'goto file in vsplit' })

vim.keymap.set('n', '<F5>', '<cmd>w<bar>source %<CR>', { desc = 'execute current file' })

-- fix quickfix <CR>
-- https://superuser.com/a/815422
vim.cmd([[
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
]])

-- highlight on search; clear when pressing <CR> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<CR>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<M-Left>', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', '<M-Right>', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic Error messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })

vim.cmd([[
map <F10> :NvimTreeFocus<CR>
" move lines with alt+up/down
nmap <M-Up> :m.-2<CR>
nmap <M-Down> :m.+1<CR>
]])

-- https://youtu.be/CuWfgiwI73Q?t=1343
vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<space>x', ':.lua<CR>')
vim.keymap.set('v', '<space>x', ':lua<CR>')
