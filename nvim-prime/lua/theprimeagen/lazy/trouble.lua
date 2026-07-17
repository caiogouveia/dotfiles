return {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            { "<leader>tt", function() require("trouble").toggle() end,                                     desc = "Trouble: toggle" },
            { "[t",         function() require("trouble").next({ skip_groups = true, jump = true }) end,     desc = "Trouble: next" },
            { "]t",         function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = "Trouble: previous" },
        },
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end
}
