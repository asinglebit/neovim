-- ==============================
-- Basic settings
-- ==============================
vim.g.editorconfig = false -- ignore project .editorconfig files
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

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_tab_width", { clear = true }),
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 4
		vim.opt_local.shiftwidth = 4
		vim.opt_local.softtabstop = 4
	end,
})
