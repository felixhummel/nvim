local statusline = require 'mini.statusline'
statusline.setup {
  use_icons = vim.g.have_nerd_font,
}

-- set the section for cursor location to LINE:COLUMN
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end

---@diagnostic disable-next-line: duplicate-set-field,unused-local
statusline.section_filename = function(args)
  -- File name with 'truncate', 'modified', 'readonly' flags
  -- Use relative path if truncated
  return '%f%m%r'
end
