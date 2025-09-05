-- ====================================================================
-- TREESITTER CONFIGURATION - Better syntax highlighting
-- ====================================================================

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
  context_commentstring = {
    enable = true,
  },
})