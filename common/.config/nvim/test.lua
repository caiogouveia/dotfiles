local api = vim.api
local buf = api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
	"Olá!!!",
})
local win = api.nvim_open_win(buf, true, { relative = "win", row = 3, col = 3, width = 40, height = 10 })
