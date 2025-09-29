-- ====================================================================
-- TREESITTER CONFIGURATION - Better syntax highlighting
-- ====================================================================

-- Set up ts_context_commentstring before treesitter to avoid deprecation warning
vim.g.skip_ts_context_commentstring_module = true
require('ts_context_commentstring').setup({
  enable_autocmd = false,
})

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "lua",
    "vim",
    "javascript",
    "typescript",
    "tsx",
    "json",
    "html",
    "css",
    "scss",
    "python",
    "markdown",
    "markdown_inline",
    "bash",
    "yaml",
    "toml"
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  -- context_commentstring deprecated - using ts_context_commentstring directly
})