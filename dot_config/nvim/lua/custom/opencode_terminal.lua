local M = {}
local buf
local win
local job_id
local opencode_bin = vim.fn.exepath 'opencode'

local function window_open()
  return win and vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf
end

local function open_window()
  vim.cmd 'botright vsplit'
  win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, math.max(30, math.floor(vim.o.columns * 0.40)))
end

local function start()
  if opencode_bin == '' then
    vim.notify('OpenCode is unavailable in PATH', vim.log.levels.WARN, { title = 'Neovim' })
    return false
  end

  buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = 'hide'
  vim.api.nvim_win_set_buf(win, buf)
  job_id = vim.fn.termopen({ opencode_bin, '--port', '4097' }, {
    on_exit = function() job_id = nil end,
  })
  return job_id > 0
end

function M.open()
  if window_open() then
    vim.api.nvim_set_current_win(win)
  else
    open_window()
    if buf and vim.api.nvim_buf_is_valid(buf) and job_id then
      vim.api.nvim_win_set_buf(win, buf)
    elseif not start() then
      vim.api.nvim_win_close(win, true)
      win = nil
      return
    end
  end
  vim.cmd 'startinsert'
end

function M.toggle()
  if window_open() then
    vim.api.nvim_win_close(win, true)
    win = nil
  else
    M.open()
  end
end

function M.resize(delta)
  if not window_open() then return end
  vim.api.nvim_win_set_width(win, math.max(30, vim.api.nvim_win_get_width(win) + delta))
end

return M
