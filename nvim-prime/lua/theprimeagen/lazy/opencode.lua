return {
    "NickvanDyke/opencode.nvim",
    dependencies = {
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {}

        vim.o.autoread = true

        -- Recommended keymaps
        vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
        vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end, { desc = "Execute opencode action" })
        vim.keymap.set({ "n", "t" }, "<leader>oc", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
    end,
}
