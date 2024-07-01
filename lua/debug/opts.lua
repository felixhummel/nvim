return {
  'my-plugin',
  opts = {
    foo = 'bar',
  },
  config = function(_, opts)
    require('my-plugin').setup(opts)
  end,
}
