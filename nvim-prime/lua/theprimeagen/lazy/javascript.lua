return {
    -- Indentação e sintaxe para JavaScript/JSX
    {
        "pangloss/vim-javascript",
        ft = { "javascript", "javascriptreact" },
    },
    -- Indentação e sintaxe para TypeScript/TSX
    {
        "HerringtonDarkholme/yats.vim",
        ft = { "typescript", "typescriptreact" },
    },
    -- Melhor suporte para JSX
    {
        "maxmellon/vim-jsx-pretty",
        ft = { "javascriptreact", "typescriptreact" },
    },
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = false,
                enable_check_bracket_line = false,
            })

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp_status_ok, cmp = pcall(require, "cmp")
            if cmp_status_ok then
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
        end,
    },
}
