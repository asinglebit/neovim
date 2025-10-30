vim.opt.syntax = "on"
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.fillchars:append({ eob = " " })
vim.o.cursorline = true

vim.keymap.set("n", "<leader>fp", "<cmd>Telescope project<cr>", { desc = "Projects" })

require("config.lazy")

local vscode = require("theme")
vscode.setup()
vscode.load()

-- Buffer navigation
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })