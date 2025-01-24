local function list_files_next_to(filename)
  local dir = vim.fn.fnamemodify(filename, ':h')
  local handle = io.popen('ls "' .. dir .. '"')
  if not handle then
    print('Error: Could not read directory ' .. dir)
    error()
  end

  local files = {}
  for file in handle:lines() do
    local path = dir .. '/' .. file
    if path ~= filename then
      table.insert(files, path)
    end
  end
  handle:close()
  return files
end

local function open_files_in_background()
  local current_file = vim.fn.expand('%:p')
  local files = list_files_next_to(current_file)
  local current_buf = vim.api.nvim_get_current_buf()

  for _, file in ipairs(files) do
    -- Open each file in a buffer
    vim.cmd(string.format('silent! edit %s', vim.fn.fnameescape(file)))
    -- Set buffers as read-only
    vim.api.nvim_buf_set_option(0, 'readonly', true)
  end
  -- Return to the remembered buffer
  vim.api.nvim_set_current_buf(current_buf)
end

-- open_files_in_background()
