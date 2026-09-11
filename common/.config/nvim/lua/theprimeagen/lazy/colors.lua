---@class Theme
---@field name string
---@field variant? string
---@field transparentBg boolean
---@field apply? fun()

---@class ThemeItem
---@field text string
---@field name string
---@field variant? string
---@field transparentBg boolean
---@field apply? fun()

local themes = {
	{ name = "default", transparentBg = false },
	{ name = "vesper", transparentBg = false },
	{ name = "sakura", transparentBg = false },
	{ name = "darkthrone", transparentBg = false },
	{ name = "rose-pine", transparentBg = true },
	{ name = "koda", transparentBg = false },
	{ name = "kanagawa", transparentBg = false },
	{
		name = "fluoromachine",
		variant = "retrowave",
		transparentBg = false,
		apply = function()
			pcall(require("fluoromachine").setup, {
				theme = "retrowave",
				glow = false,
				transparent = false,
			})
			vim.cmd.colorscheme("fluoromachine")
		end,
	},
	{
		name = "fluoromachine",
		variant = "delta",
		transparentBg = false,
		apply = function()
			pcall(require("fluoromachine").setup, {
				theme = "delta",
				glow = true,
				transparent = false,
			})
			vim.cmd.colorscheme("fluoromachine")
		end,
	},
	{ name = "brightburn", transparentBg = true },
	{ name = "onedark", transparentBg = false },
	{ name = "vaporwave", transparentBg = true },
	{ name = "onelight", transparentBg = false },
	{ name = "retrobox", transparentBg = false },
}

-- Nome do plugin (spec do lazy.nvim) que fornece cada tema selecionável no
-- ThemePicker. Usado para forçar o carregamento lazy do plugin certo antes
-- de aplicar um tema que ainda não foi carregado nesta sessão.
local theme_plugin_names = {
	koda = "koda.nvim",
	vesper = "Vesper",
	sakura = "sakura",
	darkthrone = "darkthrone",
	["rose-pine"] = "rose-pine",
	kanagawa = "kanagawa",
	fluoromachine = "fluoromachine",
	brightburn = "brightburn",
	onedark = "onedark",
	vaporwave = "onedark",
	onelight = "onedark",
	-- "default" e "retrobox" são colorschemes nativos do Neovim, não precisam de plugin.
}

---@param name string
---@return nil
local function ensure_theme_loaded(name)
	local plugin_name = theme_plugin_names[name]
	if plugin_name then
		pcall(function()
			require("lazy").load({ plugins = { plugin_name } })
		end)
	end
end

---@return nil
function ThemePicker()
	local original = vim.g.colors_name
	local submitted = false
	local Menu = require("nui.menu")

	local current_index = 1
	for i, t in ipairs(themes) do
		if t.name == original then
			current_index = i
			break
		end
	end

	local lines = {}
	for _, t in ipairs(themes) do
		local displayName = t.variant or t.name
		table.insert(
			lines,
			Menu.item(displayName, {
				name = t.name,
				variant = t.variant,
				transparentBg = t.transparentBg,
				apply = t.apply,
			})
		)
	end

	local menu = Menu({
		position = "50%",
		size = {
			width = 30,
			height = #lines,
		},
		border = {
			style = "rounded",
			text = {
				top = " " .. #lines .. " Themes ",
				top_align = "center",
			},
		},
	}, {
		lines = lines,
		keymap = {
			focus_next = { "j", "<Down>" },
			focus_prev = { "k", "<Up>" },
			close = { "<Esc>", "q" },
			submit = { "<CR>" },
		},
		on_change = function(item)
			---@cast item ThemeItem
			ensure_theme_loaded(item.name)
			if item.apply then
				item.apply()
			else
				vim.cmd.colorscheme(item.name)
			end
		end,
		on_submit = function(item)
			submitted = true
			---@cast item ThemeItem
			ensure_theme_loaded(item.name)
			ColorMyPencils(item)
		end,
		on_close = function()
			if not submitted then
				vim.cmd.colorscheme(original)
			end
		end,
	})

	menu:mount()

	vim.schedule(function()
		for _ = 1, current_index - 1 do
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("j", true, false, true), "n", false)
		end
	end)
end

---@param color string
---@return nil
function SetColoColumn(color)
	local columnColor = color or "#FF0000"
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = columnColor })
end

---@return nil
function SetTransparentBackground()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

---@return string
local function colorSchemeFilePath()
	return vim.fn.expand("~/.config/nvim/.colorscheme")
end

---@return Theme
local function read_persisted_theme()
	local ok, lines = pcall(vim.fn.readfile, colorSchemeFilePath())
	local saved = ok and lines[1] or nil
	if not saved then
		return { name = "vesper" }
	end
	local ok2, data = pcall(vim.json.decode, saved)
	if ok2 and type(data) == "table" then
		return data
	end
	return { name = saved }
end

---@param theme? ThemeItem|string
---@return nil
function ColorMyPencils(theme)
	local colorSchemeFile = colorSchemeFilePath()
	vim.fn.mkdir(vim.fn.fnamemodify(colorSchemeFile, ":h"), "p")

	if type(theme) ~= "table" then
		theme = read_persisted_theme()
	end

	vim.fn.writefile({
		vim.json.encode({ name = theme.name, variant = theme.variant }),
	}, colorSchemeFile)

	if theme.apply then
		theme.apply()
	else
		vim.cmd.colorscheme(theme.name)
	end

	if theme.transparentBg then
		SetTransparentBackground()
	end
	SetColoColumn("#FF00ff")
end

-- No startup, vários plugins de tema podem estar marcados como eager (veja
-- `is_eager` abaixo) para garantir que o tema persistido sempre tenha seu
-- plugin disponível. Sem essa trava, cada um chamaria ColorMyPencils() de
-- forma redundante (leitura/escrita de disco + :colorscheme repetidos).
local pencils_applied_at_startup = false
local function apply_once()
	if pencils_applied_at_startup then
		return
	end
	pencils_applied_at_startup = true
	ColorMyPencils()
end

-- Só o tema persistido em ~/.config/nvim/.colorscheme (mais os fallbacks
-- fixos abaixo) carrega no startup; os demais ficam lazy e só carregam
-- quando selecionados via ThemePicker().
local active_theme_name = read_persisted_theme().name
local ALWAYS_EAGER = { koda = true, darkthrone = true, vesper = true }

---@param plugin_theme_name string
---@return boolean
local function is_eager(plugin_theme_name)
	return ALWAYS_EAGER[plugin_theme_name] == true or plugin_theme_name == active_theme_name
end

return {
	{
		"oskarnurm/koda.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("koda").setup({ transparent = false })
			apply_once()
		end,
	},

	{
		"metalelf0/black-metal-theme-neovim",
		name = "darkthrone",
		lazy = false,
		priority = 1000,
		config = function()
			require("black-metal").setup({ theme = "darkthrone" })
			apply_once()
		end,
	},

	{
		"anAcc22/sakura.nvim",
		name = "sakura",
		dependencies = "rktjmp/lush.nvim",
		lazy = not is_eager("sakura"),
		priority = is_eager("sakura") and 1000 or nil,
		config = function()
			vim.opt.background = "dark" -- or "light"
			apply_once()
		end,
	},

	{
		"olimorris/onedarkpro.nvim",
		name = "onedark",
		lazy = not is_eager("onedark"),
		priority = is_eager("onedark") and 1000 or nil,
		config = function()
			apply_once()
		end,
	},

	{
		"MunifTanjim/nui.nvim",
		lazy = true,
	},

	{
		"erikbackman/brightburn.vim",
		name = "brightburn",
		lazy = not is_eager("brightburn"),
		priority = is_eager("brightburn") and 1000 or nil,
		config = function()
			apply_once()
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = not is_eager("rose-pine"),
		priority = is_eager("rose-pine") and 1000 or nil,
		config = function()
			apply_once()
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		lazy = not is_eager("kanagawa"),
		priority = is_eager("kanagawa") and 1000 or nil,
		config = function()
			require("kanagawa").setup({
				compile = false,
				undercurl = true,
				commentStyle = { italic = false },
				functionStyle = {},
				keywordStyle = { italic = false },
				statementStyle = { bold = true },
				typeStyle = {},
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				colors = {
					palette = {},
					theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
				},
				theme = "lotus", -- Load "wave" theme when 'background' option is not set
				background = {
					dark = "wave",
					light = "lotus",
				},
			})
			apply_once()
		end,
	},

	{
		"maxmx03/fluoromachine.nvim",
		name = "fluoromachine",
		variant = "retrowave",
		lazy = not is_eager("fluoromachine"),
		priority = is_eager("fluoromachine") and 1000 or nil,
		config = function()
			local fm = require("fluoromachine")
			fm.setup({
				glow = false,
				theme = "retrowave", -- fluoromachine, retrowave, delta, synthwave
				transparent = false,
			})
			apply_once()
		end,
	},

	{
		"datsfilipe/vesper.nvim",
		name = "Vesper",
		lazy = false,
		priority = 1000,
		config = function()
			require("vesper").setup({
				transparent = false, -- Boolean: Sets the background to transparent
				italics = {
					comments = true, -- Boolean: Italicizes comments
					keywords = true, -- Boolean: Italicizes keywords
					functions = true, -- Boolean: Italicizes functions
					strings = true, -- Boolean: Italicizes strings
					variables = true, -- Boolean: Italicizes variables
				},
				overrides = {}, -- A dictionary of group names, can be a function returning a dictionary or a table.
				palette_overrides = {},
			})
			apply_once()
		end,
	},
}
