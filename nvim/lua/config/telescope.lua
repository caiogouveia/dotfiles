-- ====================================================================
-- TELESCOPE CONFIGURATION - File finder (replaces CtrlP)
-- ====================================================================

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = "> ",
    path_display = {"truncate"},
    file_ignore_patterns = {
      "node_modules/.*",
      "vendor/.*",
      "%.git/.*",
      "%.DS_Store",
      "dist/.*",
      "build/.*",
      "coverage/.*",
      "__pycache__/.*",
      "%.pyc",
      "%.pyo",
      "%.swp",
      "%.swo"
    },
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
      n = {
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true
    },
    live_grep = {
      additional_args = function(opts)
        return {"--hidden"}
      end
    },
  },
})
