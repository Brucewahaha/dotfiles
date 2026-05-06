return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    -- 你可以在这里配置高亮颜色、跳跃的标签字符等
    -- 这里保持默认即可，默认体验已经极佳
  },
  -- 绑定相关的快捷键：
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump (代替 easymotion)" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter 选择" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter 搜索范围" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "切换 Flash 搜索" },
  },
}