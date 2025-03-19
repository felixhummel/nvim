-- https://github.com/cuducos/yaml.nvim
-- :YAMLTelescope
return {
  {
    'cuducos/yaml.nvim',
    ft = { 'yaml' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim', -- optional
    },
  },
}
