return { -- old-school fzf
  {
    'junegunn/fzf',
    dir = '~/.fzf',
    build = './install --key-bindings --completion --no-update-rc',
  },
  {
    'junegunn/fzf.vim',
    init = function()
      vim.cmd([[
" bash history completion with multiple lines
" The "--text" flag lets rg continue even if a NUL byte is found
inoremap <expr> <c-x><c-h> fzf#vim#complete({ 'source': 'rg --text -v ^# ~/.bash_history', 'options': '--multi --tac --no-sort --exact', 'reducer': { lines -> join(lines, "\n") }})
]])
    end,
  },
}
