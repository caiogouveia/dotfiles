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
	{ name = "rose-pine", transparentBg = false },
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
	{ name = "onedark", transparentBg = true },
	{ name = "vaporwave", transparentBg = true },
	{ name = "onelight", transparentBg = false },
	{ name = "retrobox", transparentBg = false },
}

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
		table.insert(lines, Menu.item(displayName, {
			name = t.name,
			variant = t.variant,
			transparentBg = t.transparentBg,
			apply = t.apply,
		}))
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
			if item.apply then
				item.apply()
			else
				vim.cmd.colorscheme(item.name)
			end
		end,
		on_submit = function(item)
			submitted = true
			---@cast item ThemeItem
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

---@param theme? ThemeItem|string
---@return nil
function ColorMyPencils(theme)
	local colorSchemeFile = vim.fn.expand("~/.config/nvim/.colorscheme")
	vim.fn.mkdir(vim.fn.fnamemodify(colorSchemeFile, ":h"), "p")

	if type(theme) ~= "table" then
		local ok, lines = pcall(vim.fn.readfile, colorSchemeFile)
		local saved = ok and lines[1] or nil
		if saved then
			local ok2, data = pcall(vim.json.decode, saved)
			if ok2 and type(data) == "table" then
				theme = data
			else
				theme = { name = saved }
			end
		else
			theme = { name = theme or "vesper" }
		end
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

return {

	{
		"MunifTanjim/nui.nvim",
		lazy = true,
	},

	{
		"erikbackman/brightburn.vim",
		name = "brightburn",
		config = function()
			ColorMyPencils()
			-- vim.api.nvim_create_autocmd("VimEnter", {
			-- 	callback = function()
			-- 		ColorMyPencils()
			-- 	end,
			-- 	once = true,
			-- })
		end,
	},

	{
		"olimorris/onedarkpro.nvim",
		priority = 1000, -- ensure it loads first
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				disable_background = false,
				styles = {
					italic = true,
				},
			})
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
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
				theme = "wave", -- Load "wave" theme when 'background' option is not set
				background = {
					dark = "wave",
					light = "lotus",
				},
			})
		end,
	},

	{
		"maxmx03/fluoromachine.nvim",
		name = "fluoromachine",
		variant = "retrowave",
		config = function()
			local fm = require("fluoromachine")
			fm.setup({
				glow = false,
				theme = "retrowave", -- fluoromachine, retrowave, delta, synthwave
				transparent = false,
			})
		end,
	},

	{
		"maxmx03/fluoromachine.nvim",
		name = "fluoromachine",
		variant = "delta",
		config = function()
			local fm = require("fluoromachine")
			fm.setup({
				glow = true,
				theme = "delta", -- fluoromachine, retrowave, delta
				transparent = false,
			})
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
		end,
	},
}
