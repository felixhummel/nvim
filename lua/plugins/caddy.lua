return {
  'isobit/vim-caddyfile',
  config = function()
    -- thanks to
    -- https://git.pub.solar/pub-solar/os/commit/f3ac27ac7123735ecaff893ad23417b0c8283382?style=unified&whitespace=show-all&show-outdated=#diff-b5eee065eddaccec600aacda1f69cad8a8aedc21
    vim.cmd('autocmd FileType caddyfile setlocal noexpandtab nolist')
  end,
}
