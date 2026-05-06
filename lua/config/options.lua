-- ==============================
-- Basic settings
-- ==============================
vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.expandtab = false -- use real tabs
vim.opt.tabstop = 4 -- tab = 4 visual spaces
vim.opt.shiftwidth = 4 -- indent = 4
vim.opt.softtabstop = 4 -- backspace/delete behaves correctly
vim.opt.smarttab = true
vim.opt.fillchars:append({ eob = " " })
vim.opt.foldenable = true
vim.o.cursorline = true
vim.g.have_nerd_font = true
