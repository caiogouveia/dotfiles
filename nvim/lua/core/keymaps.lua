-- ====================================================================
-- NEOVIM KEYMAPS - All keybindings converted from vimrc
-- ====================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable Ex mode
keymap("n", "Q", "<Nop>", opts)

-- Quick save and quit
keymap("n", "<leader>w", ":w<CR>", opts)
keymap("n", "<leader>q", ":q<CR>", opts)
keymap("n", "<leader>wq", ":wq<CR>", opts)

-- Navigation between splits
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Move splits
keymap("n", "<A-h>", "<C-W>H", opts)
keymap("n", "<A-j>", "<C-W>J", opts)
keymap("n", "<A-k>", "<C-W>K", opts)
keymap("n", "<A-l>", "<C-W>L", opts)

-- Buffer navigation (using barbar.nvim)
keymap("n", "<leader>bn", "<Cmd>BufferNext<CR>", opts)
keymap("n", "<leader>bp", "<Cmd>BufferPrevious<CR>", opts)
keymap("n", "<leader>bd", "<Cmd>BufferClose<CR>", opts)

-- Enhanced buffer navigation
-- keymap("n", "<Tab>", "<Cmd>BufferNext<CR>", opts)
-- keymap("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", opts)
keymap("n", "<leader>b", "<Cmd>BufferPick<CR>", opts)

-- Quick buffer access (numbers 1-9) - using barbar
for i = 1, 9 do
  keymap("n", "<leader>" .. i, "<Cmd>BufferGoto " .. i .. "<CR>", opts)
end

-- Additional barbar keymaps
keymap("n", "<A-,>", "<Cmd>BufferPrevious<CR>", opts)
keymap("n", "<A-.>", "<Cmd>BufferNext<CR>", opts)
keymap("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts)
keymap("n", "<A->>", "<Cmd>BufferMoveNext<CR>", opts)
keymap("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", opts)
keymap("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", opts)
keymap("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", opts)
keymap("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", opts)
keymap("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", opts)
keymap("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", opts)
keymap("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", opts)
keymap("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", opts)
keymap("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", opts)
keymap("n", "<A-0>", "<Cmd>BufferLast<CR>", opts)
keymap("n", "<A-p>", "<Cmd>BufferPin<CR>", opts)
keymap("n", "<A-c>", "<Cmd>BufferClose<CR>", opts)
keymap("n", "<leader>p", "<Cmd>BufferPick<CR>", opts)

-- Tab navigation
keymap("n", "<C-t>", ":tabnew<CR>", opts)
keymap("n", "<C-w>", ":tabclose<CR>", opts)

-- Tab navigation with Alt + number (note: conflicts with barbar Alt+number, using different keys)
keymap("n", "<A-Right>", ":tabnext<CR>", opts)
keymap("n", "<A-Left>", ":tabprevious<CR>", opts)

-- Plugin toggles (these will be updated when plugins are configured)
keymap("n", "<C-b>", ":NvimTreeToggle<CR>", opts)
keymap("n", "<C-p>", ":Telescope find_files<CR>", opts)  -- CtrlP replacement
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- Clear search highlighting
keymap("n", "<leader>/", ":nohlsearch<CR>", opts)

-- Home and End key fixes for all modes
-- Normal mode
keymap("n", "<Home>", "^", opts)  -- Go to first non-blank character
keymap("n", "<End>", "$", opts)   -- Go to end of line

-- Insert mode
keymap("i", "<Home>", "<C-o>^", opts)  -- Go to first non-blank character
keymap("i", "<End>", "<C-o>$", opts)   -- Go to end of line

-- Visual mode
keymap("v", "<Home>", "^", opts)  -- Go to first non-blank character
keymap("v", "<End>", "$", opts)   -- Go to end of line

-- Command mode
keymap("c", "<Home>", "<C-b>", opts)  -- Go to beginning of command line
keymap("c", "<End>", "<C-e>", opts)   -- Go to end of command line

-- Custom close function that allows closing last window
local function smart_close()
  local win_count = vim.fn.winnr('$')
  if win_count == 1 then
    -- If it's the last window, create a new empty buffer instead of closing
    vim.cmd('enew')
  else
    -- If there are multiple windows, close normally
    vim.cmd('close')
  end
end

-- Close all files function inspired by smart_close
local function close_all_files()
  local buffers = vim.fn.getbufinfo({buflisted = 1})

  for _, buf in ipairs(buffers) do
    -- Skip modified buffers to prevent data loss
    if not buf.changed then
      vim.api.nvim_buf_delete(buf.bufnr, {force = false})
    end
  end

  -- Check if any buffers remain
  local remaining_buffers = vim.fn.getbufinfo({buflisted = 1})
  if #remaining_buffers == 0 then
    -- If no buffers remain, create a new empty buffer
    vim.cmd('enew')
  else
    -- If modified buffers remain, notify the user
    print("Some buffers have unsaved changes and were not closed")
  end
end

-- Override the default close behavior
keymap("n", "<C-w>c", smart_close, opts)
keymap("n", "<leader>c", smart_close, opts)

-- Close all files keybinding
keymap("n", "<leader>qa", close_all_files, opts)

-- Create a custom :close command
vim.api.nvim_create_user_command("Close", smart_close, {})

-- Create a custom :CloseAll command
vim.api.nvim_create_user_command("CloseAll", close_all_files, {})

-- Create :Q command as alias for :q
vim.api.nvim_create_user_command("Q", "q", {})

-- Create :W command as alias for :w
vim.api.nvim_create_user_command("W", "w", {})

-- Create :Wq command as alias for :wq
vim.api.nvim_create_user_command("Wq", "wq", {})

-- Terminal
keymap("n", "<C-n>", function()
  vim.cmd("split")
  vim.cmd("resize 15")
  vim.cmd("terminal")
  vim.cmd("startinsert")
end, opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- Quick edit init.lua (equivalent to vimrc editing)
keymap("n", "<leader>ev", ":vsplit ~/.config/nvim/init.lua<CR>", opts)
keymap("n", "<leader>sv", ":source ~/.config/nvim/init.lua<CR>", opts)

-- Claude Code integration keymaps
keymap("n", "<leader>cc", function()
  local input = vim.fn.input("Claude Code: ")
  if input ~= "" then
    vim.cmd('!claude "' .. input .. '"')
  end
end, { noremap = true, desc = "Claude Code Interact" })

keymap("n", "<leader>ca", function()
  local filename = vim.fn.expand("%:p")
  if filename ~= "" then
    vim.cmd('!claude "Analyze this file: ' .. filename .. '"')
  else
    print("No file to analyze")
  end
end, { noremap = true, desc = "Claude Code Analyze" })

keymap("n", "<leader>cf", function()
  local filename = vim.fn.expand("%:p")
  if filename ~= "" then
    vim.cmd('!claude "Fix any issues in this file: ' .. filename .. '"')
  else
    print("No file to fix")
  end
end, { noremap = true, desc = "Claude Code Fix" })

keymap("n", "<leader>gc", function()
  vim.cmd('!claude "Create a git commit for the current changes"')
end, { noremap = true, desc = "Claude Code Commit" })

keymap("v", "<leader>ce", function()
  local text = vim.fn.getreg("*")
  if text ~= "" then
    vim.cmd('!claude "Explain this code: ' .. text .. '"')
  else
    print("No text selected")
  end
end, { noremap = true, desc = "Claude Code Explain" })
