-- Remove '=' from the list of characters considered part of a filename
-- to allow completion of ExecStart=/foo/ba
vim.opt.isfname:remove('=')
