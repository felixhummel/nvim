-- find out why '[T]oggle Inlay [H]ints' in plugins/nvim-lspconfig.lua does not appear
local current_buffer = 0
local _clients = vim.lsp.get_active_clients { bufnr = current_buffer }
local client = _clients[1]
-- print(vim.inspect(client)) -- and vim.lsp.inlay_hint then
-- print(vim.inspect(client.server_capabilities.inlayHintProvider)) -- and vim.lsp.inlay_hint then
print(vim.inspect(vim.lsp.inlay_hint))

-- inlay_hint is disabled
-- enable with
-- {
--   "neovim/nvim-lspconfig",
--   opts = {
--     inlay_hints = { enabled = true },
--   },
-- }
-- https://www.reddit.com/r/neovim/comments/14e41rb/comment/joxh0v0/
