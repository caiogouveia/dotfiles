-- Debug script para verificar treesitter e indentação
print("=== TREESITTER DEBUG ===")

-- Verificar se treesitter está carregado
local ts_ok, ts = pcall(require, "nvim-treesitter")
print("Treesitter loaded: " .. tostring(ts_ok))

-- Verificar se indent module está disponível
local indent_ok, indent = pcall(require, "nvim-treesitter.indent")
print("Treesitter indent module loaded: " .. tostring(indent_ok))

-- Verificar se treesitter está ativo no buffer
print("Treesitter active in buffer: " .. tostring(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] ~= nil))

-- Verificar parsers específicos
local parsers = {"javascript", "typescript", "tsx", "jsx"}
for _, parser in ipairs(parsers) do
    local parser_ok = pcall(vim.treesitter.language.add, parser)
    print("Parser " .. parser .. " available: " .. tostring(parser_ok))
end

-- Verificar configurações de indentação
print("\n=== INDENT SETTINGS ===")
print("tabstop: " .. vim.opt.tabstop:get())
print("shiftwidth: " .. vim.opt.shiftwidth:get())
print("expandtab: " .. tostring(vim.opt.expandtab:get()))
print("smartindent: " .. tostring(vim.opt.smartindent:get()))
print("autoindent: " .. tostring(vim.opt.autoindent:get()))

-- Verificar se está em um arquivo JS/TS
print("\n=== FILETYPE ===")
print("Current filetype: " .. vim.bo.filetype)
print("Current tabstop: " .. vim.bo.tabstop)
print("Current shiftwidth: " .. vim.bo.shiftwidth)
