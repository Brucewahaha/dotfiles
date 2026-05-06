-- =====================================================================
-- 从 VS Code Vim 迁移过来的自定义快捷键
-- =====================================================================

-- jj 退出插入模式
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

-- C-n 取消高亮
vim.keymap.set('n', '<C-n>', ':nohlsearch<CR>', { desc = 'Clear highlight' })


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