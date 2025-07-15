local function run_ty_and_populate_qf()
  -- Run ty and capture output
  local handle = io.popen('ty check src/')
  local result = handle:read('*a')
  handle:close()

  -- Parse the output
  local qf_list = {}
  for line in result:gmatch('[^\r\n]+') do
    local filename, line_num, col_num = line:match('%--> ([^:]+):(%d+):(%d+)')
    if filename and line_num and col_num then
      table.insert(qf_list, {
        filename = filename,
        lnum = tonumber(line_num),
        col = tonumber(col_num),
        text = line,
      })
    end
  end

  -- Set the quickfix list
  vim.fn.setqflist(qf_list)
  vim.cmd('copen') -- Open quickfix window
end

-- Create a command
vim.api.nvim_create_user_command('RunTy', run_ty_and_populate_qf, {})
