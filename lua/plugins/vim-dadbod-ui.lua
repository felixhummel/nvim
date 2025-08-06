return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true, cmd = { 'DB' } },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_tmp_query_location = '~/.local/share/db_ui/queries'
    vim.g.db_ui_show_database_icon = 1
    vim.cmd('autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni')
  end,
}
