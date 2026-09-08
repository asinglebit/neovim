-- ==============================
-- Basic settings
-- ==============================
vim.g.editorconfig = false -- ignore project .editorconfig files
-- No `syntax on` here: Neovim enables syntax by default, and calling it explicitly re-ran
-- filetype detection on a file passed as a command-line argument *before* the FileType autocmds
-- below were registered -- so `nvim note.md` silently missed all the markdown settings.
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

-- ==============================
-- Markdown / Obsidian notes
-- ==============================
-- No `markdown_folding`: it folds via MarkdownFold(), which detects code blocks by asking the
-- regex syntax engine. Neovim 0.12's markdown ftplugin calls vim.treesitter.start(), which turns
-- regex syntax off, so every `#` comment inside a fenced block became a heading. Treesitter's own
-- folds.scm gets this right.

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("user_markdown", { clear = true }),
	pattern = "markdown",
	callback = function()
		vim.opt_local.expandtab = true -- tab-indented lists do not render in Obsidian
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.wrap = false -- a wrapped row breaks the table renderer's column lines
		vim.opt_local.sidescrolloff = 8 -- neominimap sets this to 36 globally
		vim.opt_local.linebreak = true -- both only apply once wrap is toggled back on
		vim.opt_local.breakindent = true

		vim.wo[0][0].foldmethod = "expr"
		vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt_local.foldlevel = 99 -- foldenable would otherwise open notes collapsed

		vim.keymap.set("n", "<leader>ow", function()
			vim.wo.wrap = not vim.wo.wrap
		end, { buf = 0, desc = "Toggle wrap" })
	end,
})
