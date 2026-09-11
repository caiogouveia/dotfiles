-- ====================================================================
-- THEME & COLORS - Visual customization
-- ====================================================================

-- Enable syntax highlighting
vim.cmd("syntax enable")

-- Set colorscheme (using vscode theme as equivalent to codedark)
-- Try multiple themes in order of preference
-- Mude a ordem aqui para trocar o tema padrão
local themes = {"neobones", "onedark", "vscode", "tokyonight", "nord", "default" }
for _, theme in ipairs(themes) do
  local success = pcall(vim.cmd, "colorscheme " .. theme)
  if success then
    break
  end
end

-- Custom highlights
local function set_highlights()
  -- Background is NOT transparent - using theme's original background
  -- If you want transparent background, uncomment the lines below:
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
  -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })

  -- Color column highlight - red line at 80 characters
  vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#ff0000", fg = "NONE" })

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
    return { "neobones", "nordbones", "rosebones", "seoulbones", "forestbones", "duckbones", "kanagawabones", "onedark", "onedark_dark", "onedark_vivid", "onelight", "vaporwave", "tokyonight", "tokyonight-night", "tokyonight-storm", "tokyonight-day", "vscode", "nord", "default" }
  end
})
