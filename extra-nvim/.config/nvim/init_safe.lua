-- ====================================================================
-- SAFE NEOVIM CONFIGURATION - No remote plugins conflicts
-- ====================================================================

-- Completely disable remote plugins and problematic features
vim.g.loaded_remote_plugins = 1
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Load basic configuration first
require('core.options')
require('core.keymaps') 
require('core.autocommands')

-- Install lazy.nvim manually first
local lazypath = vim.fn.expand("~/.config/nvim/lazy/lazy.nvim")
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({ "mkdir", "-p", vim.fn.expand("~/.config/nvim/lazy") })
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  print("Installation complete! Please restart Neovim.")
  return
end

vim.opt.rtp:prepend(lazypath)

-- Only load plugins after lazy.nvim is confirmed installed
local ok, lazy = pcall(require, "lazy")
if not ok then
  print("lazy.nvim not ready yet, please restart Neovim")
  return
end

-- Minimal plugin setup
lazy.setup({
  -- Essential plugins only
  { "tpope/vim-commentary" },
  { "nvim-tree/nvim-web-devicons" },
  { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
}, {
  ui = { border = "rounded" },
  checker = { enabled = false }, -- Disable update checker initially
})

-- Set colorscheme
pcall(vim.cmd, "colorscheme tokyonight")

print("Safe configuration loaded!")