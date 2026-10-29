return {
	"stevearc/conform.nvim",
	opts = {},
	event = "BufWritePre",
	config = function()
		-- Trava de segurança: nenhum formatter pode apagar comentários
		-- (inclusive código comentado). Se algum comentário sumir, a
		-- formatação é desfeita e o buffer volta ao estado anterior.
		local function normalize(s)
			-- ignora espaços e marcadores (//, ///, /* */, #, --), que os formatters podem mudar
			return (s:gsub("[%s/%*#%-]", ""))
		end

		local function comment_chunks(bufnr, lines)
			local chunks = {}
			local ft = vim.bo[bufnr].filetype
			local lang = vim.treesitter.language.get_lang(ft) or ft
			local ok, parser = pcall(vim.treesitter.get_string_parser, table.concat(lines, "\n"), lang)
			if ok and parser then
				parser:parse(true)
				local function walk(node)
					if node:type():find("comment") then
						table.insert(chunks, vim.treesitter.get_node_text(node, parser:source()))
						return
					end
					for child in node:iter_children() do
						walk(child)
					end
				end
				parser:for_each_tree(function(tree)
					walk(tree:root())
				end)
				return chunks
			end
			-- sem parser treesitter: usa o commentstring linha a linha
			local prefix = vim.trim((vim.bo[bufnr].commentstring or ""):gsub("%%s.*$", ""))
			if prefix == "" then
				return chunks
			end
			for _, line in ipairs(lines) do
				local i = line:find(prefix, 1, true)
				if i then
					table.insert(chunks, line:sub(i))
				end
			end
			return chunks
		end

		local function missing_comment(before, after)
			local blob = normalize(table.concat(after, "\n"))
			for _, chunk in ipairs(before) do
				local norm = normalize(chunk)
				if norm ~= "" then
					local i, j = blob:find(norm, 1, true)
					if not i then
						return chunk
					end
					blob = blob:sub(1, i - 1) .. blob:sub(j + 1)
				end
			end
		end

		local function safe_format(bufnr)
			bufnr = (bufnr == nil or bufnr == 0) and vim.api.nvim_get_current_buf() or bufnr
			local before = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local before_comments = comment_chunks(bufnr, before)
			local view = vim.fn.winsaveview()

			require("conform").format({
				bufnr = bufnr,
				async = false,
				timeout_ms = 5000,
				lsp_format = "fallback",
			})

			local after = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local lost = missing_comment(before_comments, comment_chunks(bufnr, after))
			if lost then
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, before)
				vim.fn.winrestview(view)
				vim.notify(
					"Formatação desfeita: o formatter removeria/alteraria comentários:\n" .. lost,
					vim.log.levels.ERROR
				)
			end
		end

		require("conform").setup({
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
				-- swift-format (Apple) só se o projeto tiver .swift-format; senão SwiftFormat
				swift = { "swift_format", "swiftformat", stop_after_first = true },
				kotlin = { "ktlint" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
				-- não deixa o SwiftFormat mexer em comentários
				-- (docComments transforma "// código" em "/// código"; fileHeader reescreve o cabeçalho)
				swiftformat = {
					prepend_args = { "--disable", "docComments,fileHeader,headerFileName,todos" },
				},
				swift_format = {
					condition = function(_, ctx)
						return vim.fs.find(".swift-format", { path = ctx.dirname, upward = true })[1] ~= nil
					end,
				},
				-- ktlint sai com 1 quando sobram violações não corrigíveis
				-- (ex.: @Composable em PascalCase), mas o stdout já vem formatado
				ktlint = {
					exit_codes = { 0, 1 },
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
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("SafeFormatOnSave", { clear = true }),
			callback = function(args)
				safe_format(args.buf)
			end,
		})

		vim.keymap.set("n", "<leader>f", function()
			safe_format(0)
		end)
	end,
}
