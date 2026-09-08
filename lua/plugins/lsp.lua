return {
	-- Rust: LSP and DAP via rustaceanvim. Everything else is in lua/config/lsp.lua.
	-- v9 is the current line and requires 0.12 -- the 0.12 readiness fixes landed in v7, so the
	-- previous `^6` pin (v6.9.7, Nov 2025) predated them.
	{
		"mrcjkb/rustaceanvim",
		version = "^9",
		lazy = false, -- rustaceanvim sets up its own ftplugin; do not lazy-load on ft
		dependencies = { "nvim-treesitter/nvim-treesitter", "mason-org/mason.nvim" },
		config = function()
			-- keymaps come from the shared LspAttach handler in lua/config/lsp.lua
			vim.g.rustaceanvim = {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = true,
							inlayHints = { enable = true },
						},
					},
					capabilities = (function()
						local caps = vim.lsp.protocol.make_client_capabilities()
						local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
						if ok then
							caps = vim.tbl_deep_extend("force", caps, cmp_nvim_lsp.default_capabilities())
						end
						return caps
					end)(),
				},
			}
		end,
	},
}
