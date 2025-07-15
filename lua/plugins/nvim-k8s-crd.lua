return {
  {
    'anasinnyk/nvim-k8s-crd',
    enabled = false,
    event = { 'BufEnter *.yaml' },
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      cache_dir = vim.fn.expand('~/.cache/k8s-schemas/'),
      k8s = {
        file_mask = '*.yaml',
      },
    },
  },
}
