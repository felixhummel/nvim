local BUFFER_NAME = 'execute'

function ExecuteStuff()
  local current_line = vim.api.nvim_get_current_line()
  if vim.bo.filetype == 'sh' then
    -- delete previous execute buffer
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
  end
end

vim.cmd('command! ExecuteStuff lua ExecuteStuff()')
vim.keymap.set('n', '<leader><Enter>', ExecuteStuff, { desc = 'Execute stuff under cursor' })

-- :lua vim.print(vim.api.nvim_list_bufs())
