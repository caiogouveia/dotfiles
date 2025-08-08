-- ====================================================================
-- PLUGIN MANAGER SETUP - Using lazy.nvim instead of vim-plug
-- ====================================================================

-- Bootstrap lazy.nvim
local lazy = require('plugins.bootstrap').setup()

-- Plugin specifications
local plugins = {
  -- Core functionality
  {
    "github/copilot.vim",
    config = function()
      -- Copilot configuration can be added here if needed
    end
  },
  
  -- File finder (telescope instead of ctrlp for better Neovim integration)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      pcall(require, 'config.telescope')
    end
  },
  
  -- File explorer (nvim-tree instead of nerdtree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      pcall(require, 'config.nvim-tree')
    end
  },
  
  -- Git integration
  {
    "tpope/vim-fugitive"
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      pcall(require, 'config.gitsigns')
    end
  },
  
  -- Startup screen
  {
    "goolord/alpha-nvim",
    config = function()
      pcall(require, 'config.alpha')
    end
  },
  
  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      pcall(require, 'config.lualine')
    end
  },
  
  -- Buffer line
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      pcall(require, 'config.bufferline')
    end
  },
  
  -- LSP and completion
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      pcall(require, 'config.lsp')
    end
  },
  
  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      pcall(require, 'config.treesitter')
    end
  },
  
  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      pcall(require, 'config.autopairs')
    end
  },
  
  -- Commentary
  {
    "tpope/vim-commentary"
  },
  
  -- Themes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "arcticicestudio/nord-vim"
  },
  {
    "Mofiqul/vscode.nvim"
  },
  
  -- Formatting
  {
    "stevearc/conform.nvim",
    config = function()
      pcall(require, 'config.conform')
    end
  },
  
  -- Additional language support
  {
    "styled-components/vim-styled-components",
    ft = {"javascript", "typescript", "javascriptreact", "typescriptreact"}
  }
}

-- Setup lazy.nvim with custom root directory
lazy.setup(plugins, {
  root = vim.fn.expand("~/.config/nvim/lazy"), -- Use config directory instead of data
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})