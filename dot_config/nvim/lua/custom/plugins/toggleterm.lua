return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup({
      -- 设定快捷键为 Ctrl + \ (很多人用作唤出终端的默认键)
      open_mapping = [[<C-`>]],
      direction = 'horizontal', -- 也可以改成 'float' 变成居中的悬浮终端
      size = 15,
      shade_terminals = true,
      float_opts = {
        border = 'curved',
      },
    })
  end,
}