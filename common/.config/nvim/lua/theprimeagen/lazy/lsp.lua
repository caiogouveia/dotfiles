return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    event = { "BufReadPre", "BufNewFile" },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        -- Keymaps do LSP
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', function()
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        if vim.api.nvim_win_get_config(win).zindex then
                            vim.api.nvim_win_close(win, true)
                            return
                        end
                    end
                    -- vim.lsp.buf.hover()
                    vim.lsp.buf.hover({
                        border = "rounded",   -- ← INVÁLIDO no 0.11
                        title = " Hover ",
                        max_width = 80,
                    })
                end, opts)
                vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts)
                vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
                vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)
                vim.keymap.set('n', '<leader>vca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', '<leader>vrr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>vrn', vim.lsp.buf.rename, opts)
                vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
            end,
        })

        -- Configs dos servidores (Neovim 0.11+). O mason-lspconfig v2 só instala
        -- e habilita (vim.lsp.enable) os servidores; as configs ficam aqui.
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        vim.lsp.config("zls", {
            root_markers = { ".git", "build.zig", "zls.json" },
            settings = {
                zls = {
                    enable_inlay_hints = true,
                    enable_snippets = true,
                    warn_style = true,
                },
            },
        })
        vim.g.zig_fmt_parse_errors = 0
        vim.g.zig_fmt_autosave = 0

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                    format = {
                        enable = true,
                        -- Put format options here
                        -- NOTE: the value should be STRING!!
                        defaultConfig = {
                            indent_style = "space",
                            indent_size = "2",
                        }
                    },
                }
            }
        })

        vim.lsp.config("tailwindcss", {
            filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "heex" },
        })

        vim.lsp.config("vtsls", {
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        })

        -- Swift/SwiftUI: sourcekit-lsp vem com o Xcode/toolchain (não está no mason).
        -- Para projetos .xcodeproj, gere o buildServer.json com xcode-build-server.
        vim.lsp.config("sourcekit", {
            filetypes = { "swift", "objc", "objcpp" },
        })
        vim.lsp.enable("sourcekit")

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "vtsls",
                "tailwindcss",
                "kotlin_lsp", -- LSP oficial da JetBrains (Kotlin/Compose)
            },
        })

        -- Formatters fora do lspconfig (usados pelo conform)
        require("mason-tool-installer").setup({
            ensure_installed = {
                "swiftformat",
                "ktlint",
            },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<Enter>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        -- vim.diagnostic.config({
        --     virtual_text = {
        --         prefix = '●',
        --         source = "if_many",
        --     },
        --     signs = {
        --         text = {
        --             [vim.diagnostic.severity.ERROR] = " ",
        --             [vim.diagnostic.severity.WARN] = " ",
        --             [vim.diagnostic.severity.INFO] = " ",
        --             [vim.diagnostic.severity.HINT] = "󰠠 ",
        --         },
        --     },
        --     underline = true,
        --     update_in_insert = false,
        --     severity_sort = true,
        --     float = {
        --         focusable = false,
        --         style = "minimal",
        --         border = "rounded",
        --         source = "always",
        --         header = "",
        --         prefix = "",
        --     },
        -- })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

    end
}
