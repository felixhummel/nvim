vim.keymap.set('n', '<C-p>', '"+p', { desc = 'paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<C-y>', '"+y', { desc = 'copy to system clipboard' })

vim.keymap.set('n', '<F5>', '<cmd>w<bar>source %<CR>', { desc = 'execute current file' })

-- highlight on search; clear when pressing <CR> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<CR>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<M-Left>', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', '<M-Right>', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.cmd [[
map <F10> :NvimTreeFocus<CR>
" move lines with alt+up/down
map <M-Up> :m.-2<CR>
map <M-Down> :m.+1<CR>
]]
