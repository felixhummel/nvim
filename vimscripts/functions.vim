" https://vi.stackexchange.com/a/5952
" ChatGPT for "range"
" https://chat.openai.com/share/2d6bd948-e193-470b-9061-56747d8b2521
function! StripTrailingWhitespace() range
    " Save cursor position
    let l:save = winsaveview()
    " Remove trailing whitespace for the specified range
    execute a:firstline . ',' . a:lastline . 's/\s\+$//e'
    " Move cursor to original position
    call winrestview(l:save)
    echo "Stripped trailing whitespace"
endfunction
command -range=% StripTrailingWhitespace :<line1>,<line2>call StripTrailingWhitespace()


" https://codegoalie.com/posts/format-json-nvim-jq/
function! FelixFormatJSON()
    :%!jq .
endfunction
command FelixFormatJSON call FelixFormatJSON()
