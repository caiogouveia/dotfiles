-- ====================================================================
-- NEOVIM OPTIONS - Basic settings converted from vimrc
-- ====================================================================

local opt = vim.opt
local g = vim.g

-- map leader to spaces
g.mapleader = " "
g.maplocalleader = " "

-- Basic settings
opt.compatible = false                -- Disable Vi compatibility
opt.encoding = "utf-8"               -- Set encoding
opt.backspace = {"indent", "eol", "start"}  -- Allow backspace over everything
opt.hidden = true                    -- Allow switching buffers without saving

-- Performance
opt.ttyfast = true                   -- Faster redrawing
-- opt.lazyredraw = true               -- Don't redraw during macros (disabled for noice.nvim compatibility)
opt.updatetime = 250                -- Faster updates

-- Files & Backups
opt.backup = false
opt.writebackup = false
opt.swapfile = false

-- Search
opt.ignorecase = true               -- Case insensitive search
opt.smartcase = true                -- Case sensitive if uppercase present
opt.hlsearch = true                 -- Highlight search results
opt.incsearch = true                -- Incremental search

-- Indentation
opt.expandtab = true                -- Use spaces instead of tabs
opt.tabstop = 2                     -- Tab width
opt.shiftwidth = 2                  -- Indentation width
opt.smartindent = true              -- Smart indenting
opt.autoindent = true               -- Auto indenting

-- UI
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers
opt.cursorline = true               -- Highlight current line
opt.ruler = true                    -- Show cursor position
opt.showcmd = true                  -- Show incomplete commands
opt.wildmenu = true                 -- Enhanced command completion
opt.wildmode = {"list", "longest"}  -- Complete files like shell
opt.laststatus = 2                  -- Always show status line
opt.showmatch = true                -- Show matching brackets
opt.colorcolumn = {"80", "120"}     -- Show column guides

-- Splits
opt.splitright = true               -- Vertical splits to the right
opt.splitbelow = true               -- Horizontal splits below
opt.fillchars:append("vert:│")      -- Better split separator

-- Mouse & Clipboard
opt.mouse = "a"                     -- Enable mouse support
opt.clipboard = "unnamed"           -- Use system clipboard

-- Folding (disabled by default)
opt.foldenable = false

-- Visual enhancements
opt.list = true
opt.listchars = {
  tab = "▸ ",
  trail = "⋅",
  extends = "❯",
  precedes = "❮",
  nbsp = "⋅"
}

-- Better display for messages
opt.cmdheight = 2

-- Don't show mode in command line (status line shows it)
opt.showmode = false

-- Performance optimizations
opt.synmaxcol = 200                 -- Limit syntax highlighting for long lines
opt.scrolljump = 5                  -- Faster scrolling
opt.timeoutlen = 500               -- Reduce timeout for mapped sequences
opt.ttimeoutlen = 50
