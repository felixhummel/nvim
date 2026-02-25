local function map_cmd(mode, mapping, cmd, desc)
  desc = desc or cmd
  vim.keymap.set(mode, mapping, '<cmd>' .. cmd .. '<CR>', { desc = desc })
end

map_cmd('n', '<C-p>', 'FelixClip', 'paste from system clipboard')
map_cmd('n', 'gF', 'vertical wincmd f', 'goto file in vsplit')
map_cmd('n', '<F5>', 'w<bar>source %')

vim.keymap.set({ 'n' }, '<C-y>', 'V"+y', { desc = 'copy line to system clipboard' })
vim.keymap.set({ 'v' }, '<C-y>', '"+y', { desc = 'copy selection to system clipboard' })

-- fix quickfix <CR>
-- https://superuser.com/a/815422
vim.cmd([[
autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
]])

-- highlight on search; clear when pressing <CR> in normal mode
vim.opt.hlsearch = true
map_cmd('n', '<CR>', 'nohlsearch')

-- Diagnostic keymaps
vim.keymap.set('n', '<M-Left>', vim.diagnostic.goto_prev, { desc = 'Go to previous Diagnostic message' })
vim.keymap.set('n', '<M-Right>', vim.diagnostic.goto_next, { desc = 'Go to next Diagnostic message' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Show diagnostic Error messages' })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Open diagnostic Quickfix list' })

vim.cmd([[
" move lines with alt+up/down
nmap <M-Up> :m.-2<CR>
nmap <M-Down> :m.+1<CR>

" uses mini.surround
vmap ` sa`
vmap ' sa'
vmap ] sa]
vmap ~ 2sa~

" surround code block, e.g. Vjj\`
vmap <leader>` c```<CR>```<ESC>P

]])

-- https://youtu.be/CuWfgiwI73Q?t=1343
map_cmd('n', '<space><space>x', 'source %')
map_cmd('n', '<space>x', '.lua')
map_cmd('v', '<space>x', 'lua')

map_cmd('n', '<leader>cs', 'AerialToggle!', 'Structure (AerialToggle)')

-- link for word under cursor or visual selection
vim.cmd([[
nmap <C-k> ciw[<C-r>"]()<Left>
vmap <C-k> c[<C-r>"]()<Left>
]])

map_cmd('n', '<leader>o', 'Oil')
map_cmd('n', '<leader>DD', '<cmd>DBUI')
