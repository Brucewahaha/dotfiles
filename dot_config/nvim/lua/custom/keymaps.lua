-- =====================================================================
-- 从 VS Code Vim 迁移过来的自定义快捷键
-- =====================================================================

-- jj 退出插入模式
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

-- C-n 取消高亮
vim.keymap.set('n', '<C-n>', ':nohlsearch<CR>', { desc = 'Clear highlight' })

local function with_module(module, callback)
  local ok, value = pcall(require, module)
  if not ok then
    vim.notify(module .. ' is unavailable', vim.log.levels.WARN, { title = 'Neovim' })
    return
  end
  callback(value)
end

vim.api.nvim_create_user_command('OpenCodeToggle', function()
  require('custom.opencode_terminal').toggle()
end, {})

vim.keymap.set({ 'n', 't' }, '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle terminal' })

-- AI completion starts disabled; toggle it with <leader>at and trigger it with Alt+y.
vim.keymap.set('n', '<leader>at', function()
  with_module('minuet', function() vim.cmd 'Minuet blink toggle' end)
end, { desc = 'Toggle AI completion' })
vim.keymap.set('i', '<A-y>', function()
  with_module('minuet', function() vim.cmd 'Minuet blink' end)
end, { desc = 'Trigger AI completion' })

vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
  with_module('opencode', function(opencode) opencode.ask('@this: ') end)
end, { desc = 'Ask OpenCode' })
vim.keymap.set({ 'n', 'x' }, '<leader>os', function()
  with_module('opencode', function(opencode) opencode.select() end)
end, { desc = 'Select OpenCode action' })
vim.keymap.set('n', '<leader>oc', function()
  with_module('opencode', function(opencode) opencode.command('session.compact') end)
end, { desc = 'Compact OpenCode session' })
vim.keymap.set('n', '<leader>on', function()
  with_module('opencode', function(opencode) opencode.command('session.new') end)
end, { desc = 'New OpenCode session' })
vim.keymap.set('n', '<leader>ou', function()
  with_module('opencode', function(opencode) opencode.command('session.half.page.up') end)
end, { desc = 'Scroll OpenCode up' })
vim.keymap.set('n', '<leader>od', function()
  with_module('opencode', function(opencode) opencode.command('session.half.page.down') end)
end, { desc = 'Scroll OpenCode down' })
vim.keymap.set('n', '<leader>oi', function()
  with_module('opencode', function(opencode) opencode.command('session.interrupt') end)
end, { desc = 'Interrupt OpenCode' })
vim.keymap.set({ 'n', 't' }, '<C-.>', function()
  with_module('custom.opencode_terminal', function(terminal) terminal.toggle() end)
end, { desc = 'Toggle OpenCode terminal' })
vim.keymap.set({ 'n', 't' }, '<leader>ot', function()
  with_module('custom.opencode_terminal', function(terminal) terminal.toggle() end)
end, { desc = 'Toggle OpenCode terminal' })
vim.keymap.set({ 'n', 't' }, '<leader>o[', function()
  with_module('custom.opencode_terminal', function(terminal) terminal.resize(5) end)
end, { desc = 'Make OpenCode wider' })
vim.keymap.set({ 'n', 't' }, '<leader>o]', function()
  with_module('custom.opencode_terminal', function(terminal) terminal.resize(-5) end)
end, { desc = 'Make OpenCode narrower' })

-- Match the common VS Code comment shortcut. Some terminals send Ctrl+/ as Ctrl-_.
for _, key in ipairs { '<C-/>', '<C-_>' } do
  vim.keymap.set('n', key, 'gcc', { remap = true, desc = 'Toggle line comment' })
  vim.keymap.set('x', key, 'gc', { remap = true, desc = 'Toggle comment' })
end


-- [[ 跳转与资源管理器 ]]
-- <leader>e 打开文件树 (需开启 neo-tree 插件)
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle Explorer' })
-- <C-e> 聚焦文件树
vim.keymap.set('n', '<C-e>', ':Neotree focus<CR>', { desc = 'Focus Explorer' })


-- ]<space> 和 [<space> 插入空行
vim.keymap.set('n', ']<space>', 'o<Esc>', { silent = true, desc = 'Insert line below' })
vim.keymap.set('n', '[<space>', 'O<Esc>', { silent = true, desc = 'Insert line above' })

-- 切换 Buffer
vim.keymap.set('n', '[b', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', ':bnext<CR>', { desc = 'Next buffer' })

-- <leader>a 快速全选
vim.keymap.set('n', '<leader>a', 'ggVG', { desc = 'Select All' })

-- [[ Alt+n/p 上下移动当前行 ]]
vim.keymap.set('n', '<A-n>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-p>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-n>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-p>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- [[ Insert 模式下的 Emacs 风格按键绑定 ]]
-- local ins_maps = {
--   { '<C-a>', '<C-o>^', 'Home' },
--   { '<C-e>', '<C-o>$', 'End' },
--   { '<C-f>', '<Right>', 'Right' },
--   { '<C-b>', '<Left>', 'Left' },
--   { '<C-p>', '<Up>', 'Up' },
--   { '<C-n>', '<Down>', 'Down' },
--   { '<C-d>', '<Del>', 'Delete right' },
--   { '<C-k>', '<C-o>D', 'Delete all right' },
--   { '<C-y>', '<C-r>+', 'Paste from clipboard' },
--   { '<C-g>', '<Esc>', 'Escape' },
--   { '<A-d>', '<C-o>dw', 'Delete word right' },
--   { '<A-BS>', '<C-w>', 'Delete word left' },
-- }
-- for _, map in ipairs(ins_maps) do
--   vim.keymap.set('i', map[1], map[2], { desc = 'Emacs: ' .. map[3] })
-- end
