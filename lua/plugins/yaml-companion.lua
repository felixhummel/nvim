return {
  {
    'someone-stole-my-name/yaml-companion.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension('yaml_schema')
      -- local cfg = require('yaml-companion').setup({
      --   schemas = {
      --     {
      --       name = 'Kustomization',
      --       uri = 'http://json.schemastore.org/kustomization',
      --     },
      --   },
      -- })
      -- require('lspconfig')['yamlls'].setup(cfg)
    end,
  },
}
