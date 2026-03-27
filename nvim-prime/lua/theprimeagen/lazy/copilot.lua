-- return {
-- 	"copilotlsp-nvim/copilot-lsp",
-- 	init = function()
-- 		vim.g.copilot_nes_debounce = 500
-- 		vim.lsp.enable("copilot")
-- 		vim.keymap.set("n", "<tab>", function()
-- 			require("copilot-lsp.nes").apply_pending_nes()
-- 		end)
-- 	end,
-- }

return {
    'github/copilot.vim',
    init = function()
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_assume_mapped = true
        vim.g.copilot_tab_fallback = ""
        vim.keymap.set("i", "<tab>", "copilot#Accept('<Tab>')", { expr = true, silent = true })
    end,

}
