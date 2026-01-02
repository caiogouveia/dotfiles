return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.config
        opts = {
            dashboard = {
                enabled = true,
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 1, padding = 1 },
                    { section = "startup" },
                },
                formats = {
                    header = [[
████████╗██████╗  █████╗ ███████╗███████╗███████╗
╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝
   ██║   ██████╔╝███████║███████╗███████╗█████╗
   ██║   ██╔══██╗██╔══██║╚════██║╚════██║██╔══╝
   ██║   ██║  ██║██║  ██║███████║███████║███████╗
   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
]],
                },
            },
        },
        keys = {
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
            { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
            { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
            { "<leader>gb", function() Snacks.gitbrowse() end, desc = "Git Browse" },
            { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
            { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
        },
    }
}

