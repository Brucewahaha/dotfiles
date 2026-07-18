local M = {}
local terminal

local function get_terminal()
  if not terminal then
    local Terminal = require('toggleterm.terminal').Terminal
    terminal = Terminal:new {
      cmd = 'opencode --port',
      direction = 'vertical',
      size = function()
        return math.floor(vim.o.columns * 0.40)
      end,
      close_on_exit = false,
      on_open = function()
        vim.cmd 'startinsert!'
      end,
    }
  end
  return terminal
end

function M.open()
  get_terminal():open()
end

function M.toggle()
  get_terminal():toggle()
end

function M.resize(delta)
  local current = get_terminal()
  if not current:is_open() then return end

  vim.api.nvim_win_call(current.window, function()
    current:resize(vim.api.nvim_win_get_width(current.window) + delta)
  end)
end

return M
