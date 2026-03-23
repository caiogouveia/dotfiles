return {
	"stevearc/conform.nvim",
	opts = {},
	event = "BufWritePre",
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 5000,
				lsp_format = "fallback",
			},
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
				lua = { "stylua" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				elixir = { "mix" },
				php = { "pint" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
				pint = {
					command = "./vendor/bin/pint",
					args = { "$FILENAME" },
					stdin = false,
					condition = function()
						local pint_path = vim.fn.getcwd() .. "/vendor/bin/pint"
						if vim.fn.filereadable(pint_path) ~= 1 then
							vim.notify("Pint não encontrado", vim.log.levels.WARN)
							return false
						end
						return true
					end,
				},
			},
		})

		vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ bufnr = 0 })
		end)
	end,
}
