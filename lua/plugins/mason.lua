return {
	-- Mason: package manager for LSPs, DAPs, formatters
	{
		"williamboman/mason.nvim",
		lazy = false,
		cmd = "Mason",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "+",
					package_pending = "*",
					package_uninstalled = "-",
				},
			},
			log_level = vim.log.levels.INFO,
			max_concurrent_installers = 4,
		},
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},

	-- Mason LSP/DAP integration
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				-- LSP server names (must match lspconfig names)
				ensure_installed = { "rust_analyzer", "ts_ls", "gopls", "lua_ls", "biome" },
				automatic_installation = true,
			})
		end,
	},

	-- Mason tool installer (for formatters / linters like stylua)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua", -- Lua formatter
					"rustfmt", -- Rust formatter
					"biome", -- JS/TS/CSS formatter
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
}
