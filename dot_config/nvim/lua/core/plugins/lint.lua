-- Linting

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    local linters_by_ft = {}
    local function add(filetypes, linter, command)
      if vim.fn.executable(command or linter) == 1 then
        for _, filetype in ipairs(filetypes) do linters_by_ft[filetype] = { linter } end
      end
    end

    add({ 'markdown' }, 'markdownlint-cli2')
    add({ 'python' }, 'ruff')
    add({ 'rust' }, 'clippy', 'cargo')
    add({ 'go' }, 'golangcilint', 'golangci-lint')
    add({ 'c', 'cpp' }, 'clangtidy', 'clang-tidy')
    add({ 'haskell' }, 'hlint')
    add({ 'clojure' }, 'clj-kondo')
    add({ 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }, 'eslint_d')
    add({ 'java' }, 'checkstyle')
    add({ 'swift' }, 'swiftlint')
    add({ 'kotlin' }, 'ktlint')
    add({ 'html' }, 'htmlhint')
    add({ 'json', 'jsonc' }, 'jsonlint')
    add({ 'sh', 'bash' }, 'shellcheck')
    lint.linters_by_ft = linters_by_ft

    -- To allow other plugins to add linters to require('lint').linters_by_ft,
    -- instead set linters_by_ft like this:
    -- lint.linters_by_ft = lint.linters_by_ft or {}
    -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
    --
    -- However, note that this will enable a set of default linters,
    -- which will cause errors unless these tools are available:
    -- {
    --   clojure = { "clj-kondo" },
    --   dockerfile = { "hadolint" },
    --   inko = { "inko" },
    --   janet = { "janet" },
    --   json = { "jsonlint" },
    --   markdown = { "vale" },
    --   rst = { "vale" },
    --   ruby = { "ruby" },
    --   terraform = { "tflint" },
    --   text = { "vale" }
    -- }
    --
    -- You can disable the default linters by setting their filetypes to nil:
    -- lint.linters_by_ft['clojure'] = nil
    -- lint.linters_by_ft['dockerfile'] = nil
    -- lint.linters_by_ft['inko'] = nil
    -- lint.linters_by_ft['janet'] = nil
    -- lint.linters_by_ft['json'] = nil
    -- lint.linters_by_ft['markdown'] = nil
    -- lint.linters_by_ft['rst'] = nil
    -- lint.linters_by_ft['ruby'] = nil
    -- lint.linters_by_ft['terraform'] = nil
    -- lint.linters_by_ft['text'] = nil

    -- Create autocommand which carries out the actual linting
    -- on the specified events.
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify in order to
        -- avoid superfluous noise, notably within the handy LSP pop-ups that
        -- describe the hovered symbol using Markdown.
        if vim.bo.modifiable then lint.try_lint() end
      end,
    })
  end,
}
