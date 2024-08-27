- [x] `<C-x><C-h>` for history completion
	- using cmp was problematic with multiple lines
	- use old school fzf as before for now
- [x] markdown code block
	- [x] ```i`<Tab>```
	- [x] ```V\````
- [x] markdown inline code with ve`
- [ ] <leader>wg
	- should [w]eb [g]oogle
		- the word under cursor
		- the visual selection
	- replace [W]orkspace (which-key)
	- prior art: https://superuser.com/questions/211989/is-there-a-vim-plugin-that-lets-you-google-the-selected-text
	- a good excuse to learn some lua scripting ;)
- `cmp.setup.cmdline` with less completions (but not the global `vim.opt.pumheight`)
- [x] use `plugins/` to make lazy reload stuff automatically
	  https://youtu.be/4zyZ3sw_ulc?list=PLsz00TDipIffreIaUNk64KxTIkQaGguqn&t=324
- [ ] make `here<TAB>` for `*.sh` work again (snippet)
- [ ] try [nvim-neoclip](https://github.com/AckslD/nvim-neoclip.lua)
- [ ] limit cmp suggestions for cmdline to 8
- [ ] try vim-dadbod (SQL)
	  [Vim Dadbod - My Favorite SQL Plugin](https://www.youtube.com/watch?v=ALGBuFLzDSA)
- [ ] notify without animations
- [ ] default indent: 2 spaces
- [ ] status line
- [ ] customize color scheme using https://github.com/rktjmp/lush.nvim
- [x] function / mapping to list key mappings in telescope
	  via [Which is Better Flash.nvim OR Leap.nvim? - YouTube](https://www.youtube.com/watch?v=eJ3XV-3uoug&t=98s)
	  was already present (thanks, TJ!) via `<leader>sk`
- [ ] nvim oil split and fix `map <F10> :NvimTreeFocus<CR>`
- [ ] try [flash.nvim](https://github.com/folke/flash.nvim)
	  via [Which is Better Flash.nvim OR Leap.nvim? - YouTube](https://www.youtube.com/watch?v=eJ3XV-3uoug&t=113s)
