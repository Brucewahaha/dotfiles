-- Add subtle indentation guides and emphasize the current scope.

---@module 'lazy'
---@type LazySpec
return {
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = 'ibl',
  ---@module 'ibl'
  ---@type ibl.config
  opts = {
    indent = { highlight = 'IblIndent' },
    scope = {
      enabled = true,
      char = '┃',
      highlight = 'IblScope',
      show_start = false,
      show_end = false,
    },
  },
}
