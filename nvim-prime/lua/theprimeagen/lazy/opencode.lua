return {
    "NickvanDyke/opencode.nvim",
    dependencies = {
        { "folke/snacks.nvim", opts = { input = {}, picker = {
            actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        }, terminal = {} } },
    },
    -- Recommended/example keymaps — declarados via `keys` para que o plugin
    -- só carregue quando um deles for pressionado pela primeira vez.
    keys = {
        { "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,   mode = { "n", "x" }, desc = "Ask opencode…" },
        { "<C-x>", function() require("opencode").select() end,                            mode = { "n", "x" }, desc = "Execute opencode action…" },
        { "<C-.>", function() require("opencode").toggle() end,                            mode = { "n", "t" }, desc = "Toggle opencode" },

        { "go",  function() return require("opencode").operator("@this ") end,             mode = { "n", "x" }, expr = true, desc = "Add range to opencode" },
        { "goo", function() return require("opencode").operator("@this ") .. "_" end,       mode = "n",          expr = true, desc = "Add line to opencode" },

        { "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   mode = "n", desc = "Scroll opencode up" },
        { "<S-C-d>", function() require("opencode").command("session.half.page.down") end, mode = "n", desc = "Scroll opencode down" },

        -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap)
        { "+", "<C-a>", mode = "n", desc = "Increment under cursor" },
        { "-", "<C-x>", mode = "n", desc = "Decrement under cursor" },
    },

    config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            -- Your configuration, if any; goto definition on the type or field for details
        }

        vim.o.autoread = true -- Required for `opts.events.reload`
    end,
}
