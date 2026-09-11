return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    keys = {
        { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "Diffview: open" },
        { "<leader>gD", "<cmd>DiffviewClose<cr>",       desc = "Diffview: close" },
        { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: file history" },
    },
}
