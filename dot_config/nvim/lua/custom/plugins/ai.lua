return {
  {
    'nickjvandyke/opencode.nvim',
    version = '*',
    event = 'VeryLazy',
    init = function()
      vim.o.autoread = true
      vim.g.opencode_opts = {
        server = {
          start = function()
            require('custom.opencode_terminal').open()
          end,
        },
      }
    end,
    config = function()
      vim.keymap.set({ 'n', 'x' }, 'go', function()
        return require('opencode').operator('@this ')
      end, { expr = true, desc = 'Send range to OpenCode' })
      vim.keymap.set('n', 'goo', function()
        return require('opencode').operator('@this ') .. '_'
      end, { expr = true, desc = 'Send line to OpenCode' })
    end,
  },
  {
    'milanglacier/minuet-ai.nvim',
    event = 'InsertEnter',
    opts = {
      provider = 'openai_compatible',
      request_timeout = 2.5,
      throttle = 1500,
      debounce = 600,
      cmp = { enable_auto_complete = false },
      blink = { enable_auto_complete = false },
      provider_options = {
        openai_compatible = {
          api_key = 'OPENAI_API_KEY',
          end_point = 'https://api.horizon1123.top/v1/chat/completions',
          model = 'gpt-5.2',
          name = 'Horizon',
          optional = {
            max_tokens = 128,
            reasoning_effort = 'none',
          },
        },
      },
    },
  },
}
