return {
    "davidmh/mdx.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = "mdx",
    config = function()
        -- Garantir que o highlighting está ativo para MDX
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "mdx",
            callback = function()
                vim.treesitter.start()
            end,
        })
    end
}
