-- ==============================
-- Diagnostics
-- ==============================
-- Signs must be declared here, not with sign_define(): Neovim 0.12 removed
-- :sign-define as a way to configure diagnostic signs (deprecated in 0.10).
vim.diagnostic.config({
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
		},
	},
	float = { border = "rounded", source = "if_many" },
})
