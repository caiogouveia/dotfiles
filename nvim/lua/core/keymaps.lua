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

-- Buffer navigation
keymap("n", "<leader>bn", ":bnext<CR>", opts)
keymap("n", "<leader>bp", ":bprevious<CR>", opts)
keymap("n", "<leader>bd", ":bdelete<CR>", opts)

-- Enhanced buffer navigation
keymap("n", "<Tab>", ":bnext<CR>", opts)
keymap("n", "<S-Tab>", ":bprevious<CR>", opts)
keymap("n", "<leader>b", ":buffers<CR>:buffer<Space>", { noremap = true })

-- Quick buffer access (numbers 1-9)
for i = 1, 9 do
  keymap("n", "<leader>" .. i, ":buffer " .. i .. "<CR>", opts)
end

-- Tab navigation
keymap("n", "<C-t>", ":tabnew<CR>", opts)
keymap("n", "<C-w>", ":tabclose<CR>", opts)

-- Tab navigation with Alt + number
for i = 1, 9 do
  keymap("n", "<A-" .. i .. ">", ":tabn " .. i .. "<CR>", opts)
end
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