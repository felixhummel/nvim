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
      local cfg = require('yaml-companion').setup({
        schemas = {
          {
            name = 'Gitlab CI',
            uri = 'https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json',
          },
        },
      })
      require('lspconfig')['yamlls'].setup(cfg)
    end,
  },
}
