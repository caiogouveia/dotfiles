-- ====================================================================
-- NEOVIM CONFIGURATION - Lua version based on existing vimrc
-- ====================================================================

-- Disable remote plugins to avoid conflicts during startup
vim.g.loaded_remote_plugins = 1

-- Load core configuration modules (these should always work)
local function safe_require(module)
  local ok, err = pcall(require, module)
  if not ok then
    vim.notify("Error loading " .. module .. ": " .. err, vim.log.levels.ERROR)
  end
end

safe_require('core.options')
safe_require('core.keymaps')
safe_require('core.autocommands')

-- Load plugins after a short delay to ensure Neovim is fully initialized
vim.defer_fn(function()
  safe_require('plugins.init')

  -- Load theme after lazy.nvim has loaded all plugins
  vim.defer_fn(function()
    safe_require('config.theme')
  end, 200)
end, 100)