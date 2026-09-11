-- ====================================================================
-- NEOVIM AUTOCOMMANDS - File type settings and auto-behaviors
-- ====================================================================

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- File type settings group
local file_type_group = augroup("FileTypeSettings", { clear = true })

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  group = file_type_group,
  pattern = "*",
  command = ":%s/\\s\\+$//e"
})

-- Set specific settings for different file types
autocmd("FileType", {
  group = file_type_group,
  pattern = {"javascript", "typescript", "json", "html", "css", "scss"},
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end
})

autocmd("FileType", {
  group = file_type_group,
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end
})

-- Terminal settings group
local terminal_group = augroup("TerminalSettings", { clear = true })

-- Auto-start insert mode in terminal
autocmd("BufEnter", {
  group = terminal_group,
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end
})

-- Highlight on yank
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = highlight_group,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-resize splits when window is resized
local resize_group = augroup("AutoResize", { clear = true })
autocmd("VimResized", {
  group = resize_group,
  pattern = "*",
  command = "wincmd ="
})