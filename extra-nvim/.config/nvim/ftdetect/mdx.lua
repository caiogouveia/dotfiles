-- ====================================================================
-- MDX FILETYPE DETECTION AND CONFIGURATION
-- ====================================================================

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.mdx",
  callback = function()
    vim.bo.filetype = "mdx"
    -- Use TSX syntax highlighting for MDX since MDX parser isn't available
    vim.treesitter.language.register("tsx", "mdx")
  end,
})

-- Configure MDX to use JSX/TSX features
vim.api.nvim_create_autocmd("FileType", {
  pattern = "mdx",
  callback = function()
    -- Enable JSX syntax features
    vim.bo.syntax = "markdown"
    -- Set commentstring for MDX files
    vim.bo.commentstring = "{/* %s */}"
    -- Enable folding
    vim.wo.foldmethod = "syntax"
  end,
})