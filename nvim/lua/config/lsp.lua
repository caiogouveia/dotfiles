-- ====================================================================
-- LSP CONFIGURATION - Language Server Protocol (replaces CoC)
-- ====================================================================

-- Setup Mason for LSP server management
require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "vtsls",        -- Usando vtsls (melhor que ts_ls)
    "html",
    "cssls",
    "jsonls",
    "eslint",
    "mdx_analyzer", -- LSP para arquivos MDX
  },
  automatic_installation = true,
})


-- LSP server configurations using new vim.lsp.config API (Neovim 0.11+)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Common on_attach function
local on_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Debug: Mostrar quando LSP está anexado
  print("LSP attached: " .. client.name .. " to buffer " .. bufnr)

  -- LSP keymaps
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

-- Configure LSP servers using new API
local servers = {
  lua_ls = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/lua-language-server") },
    filetypes = { "lua" },
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        diagnostics = { globals = {'vim'} },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
    on_attach = on_attach,
    capabilities = capabilities,
  },
  vtsls = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vtsls"), "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "mdx" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
    settings = {
      typescript = {
        preferences = {
          includeCompletionsForModuleExports = true,
        },
      },
      vtsls = {
        autoUseWorkspaceTsdk = true,
      },
    },
    on_attach = on_attach,
    capabilities = capabilities,
  },
  html = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-html-language-server"), "--stdio" },
    filetypes = { "html" },
    on_attach = on_attach,
    capabilities = capabilities,
  },
  cssls = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-css-language-server"), "--stdio" },
    filetypes = { "css", "scss", "less" },
    on_attach = on_attach,
    capabilities = capabilities,
  },
  jsonls = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-json-language-server"), "--stdio" },
    filetypes = { "json", "jsonc" },
    on_attach = on_attach,
    capabilities = capabilities,
  },
  eslint = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/vscode-eslint-language-server"), "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    on_attach = on_attach,
    capabilities = capabilities,
  },
  mdx_analyzer = {
    cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/mdx-analyzer"), "--stdio" },
    filetypes = { "mdx" },
    root_markers = { "package.json", ".git" },
    settings = {
      typescript = {
        preferences = {
          includeCompletionsForModuleExports = true,
        },
      },
    },
    on_attach = on_attach,
    capabilities = capabilities,
  },
}

-- Setup servers using vim.lsp.config
for server_name, config in pairs(servers) do
  vim.lsp.config[server_name] = config
end