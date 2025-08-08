-- ====================================================================
-- NVIM-TREE CONFIGURATION - File explorer (replaces NERDTree)
-- ====================================================================

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  respect_buf_cwd = true,
  view = {
    width = 35,
    side = "left",
  },
  renderer = {
    add_trailing = false,
    group_empty = false,
    highlight_git = false,
    highlight_opened_files = "none",
    root_folder_modifier = ":~",
    indent_markers = {
      enable = false,
    },
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  filters = {
    dotfiles = false,
    custom = { "node_modules", "\\.git$", "\\.DS_Store$" },
  },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
      },
    },
  },
})