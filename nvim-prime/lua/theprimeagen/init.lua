require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.lazy_init")
-- require("theprimeagen.snacks")
-- require("theprimeagen.lualine")
-- require("theprimeagen.bufferline")

-- DO.not
-- DO NOT INCLUDE THIS

-- If i want to keep doing lsp debugging
-- function restart_htmx_lsp()
--     require("lsp-debug-tools").restart({ expected = {}, name = "htmx-lsp", cmd = { "htmx-lsp", "--level", "DEBUG" }, root_dir = vim.loop.cwd(), });
-- end

-- DO NOT INCLUDE THIS
-- DO.not

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

function ReloadConfig()
    -- Limpar cache dos módulos
    for name, _ in pairs(package.loaded) do
        if name:match('^theprimeagen') then
            package.loaded[name] = nil
        end
    end

    -- Recarregar configuração principal
    dofile(vim.env.MYVIMRC)

    vim.notify("Config recarregada!", vim.log.levels.INFO)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.hl.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({"BufWritePre"}, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- autocmd('BufEnter', {
--     group = ThePrimeagenGroup,
--     callback = function()
--         if vim.bo.filetype == "zig" then
--             pcall(vim.cmd.colorscheme, "tokyonight-night")
--         else
--             pcall(vim.cmd.colorscheme, "rose-pine-moon")
--         end
--     end
-- })

-- Indentação para JS/TS/JSX/TSX com 4 espaços
autocmd('FileType', {
    group = ThePrimeagenGroup,
    pattern = {'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'json', 'jsonc'},
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
        -- Deixar o plugin de sintaxe controlar a indentação
        vim.opt_local.smartindent = false
        vim.opt_local.autoindent = true
    end
})


autocmd('LspAttach', {
    group = ThePrimeagenGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
