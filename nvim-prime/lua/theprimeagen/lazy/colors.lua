function ThemePicker()
    ---@class Theme -- define o tipo Theme
    ---@field name string -- campo nome
    ---@field transparentBg boolean -- theme tem bg transparente

    ---@class ThemeItem
    ---@field text string
    ---@field transparentBg boolean

    ---@type Theme[] -- themes é um array de Theme
    local themes = {
        { name = "vesper", transparentBg = true },
        { name = "rose-pine", transparentBg = true },
        { name = "kanagawa", transparentBg = true },
        { name = "fluoromachine", transparentBg = true },
        { name = "brightburn", transparentBg = true },
        { name = "onedark", transparentBg = true },
        { name = "vaporwave", transparentBg = true },
        { name = "onelight", transparentBg = false },
    }

    local original = vim.g.colors_name
    local Menu = require('nui.menu')

    -- encontra o índice do tema atual na lista
    local current_index = 1
    for i, t in ipairs(themes) do
        if t.name == original then
            current_index = i
            break
        end
    end

    local lines = {}
    for _, t in ipairs(themes) do
        table.insert(lines, Menu.item(t.name, { transparentBg = t.transparentBg }))
    end

    local menu = Menu({
        position = "50%",
        size = {
            width = 30,
            height = 10
        },
        border = {
            style = "rounded",
            text = {
                top = " Themes ",
                top_align = "center"
            }
        }
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
            vim.cmd.colorscheme(item.text)
        end,
        ---@param item Theme
        on_submit = function(item)
            ColorMyPencils(item.name, item.transparentBg)
        end,
        on_close = function()
            vim.cmd.colorscheme(original)
        end,
    })

    menu:mount()

    -- posiciona o cursor no tema atual
    vim.schedule(function()
        for _ = 1, current_index - 1 do
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("j", true, false, true),
                "n", false
            )
        end
    end)
end

---@param color string
---@return nil
function SetColoColumn(color)
	local columnColor = color or "#FF0000"
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = columnColor })
end

function SetTransparentBackground()
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

---@param color? string
---@param bg? boolean
---@return nil
function ColorMyPencils(color, bg)
	local colorSchemeFile = vim.fn.expand("~/.config/nvim/.colorscheme")
	local previousColor = color or vim.fn.readfile(colorSchemeFile)[1] or "vesper"
	vim.fn.writefile({ previousColor }, colorSchemeFile)
	vim.cmd.colorscheme(previousColor)
    local lBg = bg ~= nil and bg or false
    if (lBg) then
        SetTransparentBackground()
    end
    SetColoColumn("#FF00ff")
end

return {

	{
        "MunifTanjim/nui.nvim",
        lazy = true
    },

    {
        "erikbackman/brightburn.vim",
        name = "brightburn",
        config = function()
            ColorMyPencils()
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
					italic = false,
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
		config = function()
			local fm = require("fluoromachine")
			fm.setup({
				glow = false,
				theme = "retrowave", -- fluoromachine, retrowave, delta
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
