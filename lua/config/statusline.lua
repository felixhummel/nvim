local statusline = require 'mini.statusline'

local _getfilename = function()
  -- :help errorformat
  return '%f%m%r'
end

statusline.setup {
  content = {
    active = _getfilename,
    inactive = _getfilename,
  },
  use_icons = vim.g.have_nerd_font,
}

-- set the section for cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end
