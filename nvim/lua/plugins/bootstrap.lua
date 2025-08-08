-- ====================================================================
-- BOOTSTRAP - Simplified first-time setup
-- ====================================================================

-- This file handles the initial setup and ensures lazy.nvim is properly installed
local M = {}

function M.setup()
  -- Use a custom path in the config directory instead of stdpath
  local lazypath = vim.fn.expand("~/.config/nvim/lazy/lazy.nvim")
  
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    print("Installing lazy.nvim plugin manager...")
    
    -- Create the directory first
    vim.fn.system({ "mkdir", "-p", vim.fn.expand("~/.config/nvim/lazy") })
    
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      error("Failed to clone lazy.nvim:\n" .. out)
    end
    print("lazy.nvim installed successfully!")
  end
  
  vim.opt.rtp:prepend(lazypath)

  -- Now we can safely require lazy
  local lazy = require("lazy")
  return lazy
end

return M