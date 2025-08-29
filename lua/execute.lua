M = {}

function M.get_language_current_line()
  local buf = 0
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Get 0-indexed line number
  local ok, parser = pcall(vim.treesitter.get_parser, buf)
  if not ok or not parser then
    return vim.api.nvim_get_option_value('filetype', { buf = buf })
  end
  local range = { line, 0, line + 1, 0 }
  local lang_tree = parser:language_for_range(range)
  return lang_tree:lang()
end

local BUFFER_NAME = 'execute_shell'

function M.execute_line()
  local current_line = vim.api.nvim_get_current_line()
  -- TODO current_line.strip()
  local shell_langs = { sh = 1, bash = 1 }
  if shell_langs[M.get_language_current_line()] then
    -- delete previous execute_shell buffer
    local buf = vim.fn.bufnr(BUFFER_NAME)
    if buf >= 0 then
      local ok, err = pcall(vim.api.nvim_buf_delete, buf, { force = false })
      if not ok then
        vim.notify('err=' .. err, vim.log.levels.DEBUG)
        assert(err) -- for lua_ls
        if err:match('Failed to unload buffer.') then
          vim.notify('Execute is still running.', vim.log.levels.WARN)
          return
        end
      end
    end
    vim.cmd('split | terminal ' .. current_line)
    vim.api.nvim_buf_set_name(0, BUFFER_NAME)
    local channel = vim.bo[0].channel
    vim.api.nvim_chan_send(channel, current_line .. '\n')
    -- focus previous buffer
    vim.cmd('wincmd p')
    -- elseif vim.bo.filetype == 'lua' then
  end
end

vim.keymap.set('n', '<leader><Enter>', M.execute_line, { desc = 'Execute anything 💀' })

return M
