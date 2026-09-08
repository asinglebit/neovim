-- mason moved to the mason-org org (the old williamboman URLs still redirect) and is on v2.
return {
	-- Mason: package manager for LSPs, DAPs, formatters
	{
		"mason-org/mason.nvim",
		lazy = false,
		opts = {
			ui = {
				border = "rounded",
				backdrop = 100, -- do not dim the editor behind the modal
				icons = {
					package_installed = "+",
					package_pending = "*",
					package_uninstalled = "-",
				},
			},
			log_level = vim.log.levels.INFO,
			max_concurrent_installers = 4,
		},
	},

	-- Mason LSP integration. Used only for `ensure_installed`: every server is declared by hand
	-- in lua/config/lsp.lua, and `automatic_enable` would otherwise also call vim.lsp.enable()
	-- on packages this config never configured -- rust_analyzer included, which rustaceanvim owns.
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = { "rust_analyzer", "ts_ls", "gopls", "lua_ls", "biome" },
			automatic_enable = false,
		},
	},

	-- Mason tool installer (for formatters / linters like stylua). Still needed: mason v2 core
	-- has no ensure_installed of its own, and mason-lspconfig's is LSP-servers-only.
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua", -- Lua formatter
				"rustfmt", -- Rust formatter
				"biome", -- JS/TS/CSS formatter
				"tree-sitter-cli", -- nvim-treesitter `main` compiles parsers with this
			},
			-- no auto_update: it swapped conform.nvim's formatter binaries mid-session
			run_on_start = true,
		},
	},
}
