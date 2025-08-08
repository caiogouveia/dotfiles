-- ====================================================================
-- THEME & COLORS - Visual customization
-- ====================================================================

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Set colorscheme (using vscode theme as equivalent to codedark)
-- Try multiple themes in order of preference
-- Mude a ordem aqui para trocar o tema padrão
local themes = { "tokyonight", "vscode", "nord", "default" }
for _, theme in ipairs(themes) do
  local success = pcall(vim.cmd, "colorscheme " .. theme)
  if success then
    break
  end
end

-- Custom highlights
local function set_highlights()
  -- Color column highlight
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#2d2d2d" })
  
  -- Clear sign column background
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
  
  -- Git signs colors (will be used when gitsigns is loaded)
  vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00" })
  vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ffff00" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = "#ff0000" })
end

-- Apply highlights after colorscheme loads
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = set_highlights,
})

-- Apply highlights immediately
set_highlights()

-- Comando para trocar temas facilmente
vim.api.nvim_create_user_command("Theme", function(opts)
  local theme = opts.args
  local success = pcall(vim.cmd, "colorscheme " .. theme)
  if success then
    print("Tema alterado para: " .. theme)
    set_highlights() -- Reaplica custom highlights
  else
    print("Tema '" .. theme .. "' não encontrado")
  end
end, {
  nargs = 1,
  complete = function()
    return { "tokyonight", "tokyonight-night", "tokyonight-day", "vscode", "nord", "default" }
  end
})