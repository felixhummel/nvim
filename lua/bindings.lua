vim.keymap.set('n', '<C-p>', '"+p', { desc = 'paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<C-y>', '"+y', { desc = 'copy to system clipboard' })

vim.keymap.set('n', '<leader>x', '<cmd>w<bar>source %<CR>', { desc = 'execute current file' })
