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
			require("mason-lspconfig").setup({
				ensure_installed = { "rust_analyzer" },
				automatic_installation = true,
			})
		end,
	},

	-- Rust: LSP and DAP via rustaceanvim

	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false,
		dependencies = { "nvim-treesitter/nvim-treesitter", "williamboman/mason.nvim", "hrsh7th/nvim-cmp" },
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

			vim.g.rustaceanvim = {
				server = {
					default_settings = {
						["rust-analyzer"] = {
							cargo = { allFeatures = true },
							checkOnSave = true,
							inlayHints = { enable = true },
						},
					},
					capabilities = capabilities,
				},
			}
		end,
	},
	-- DAP UI (optional but recommended)
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "git@github.com:nvim-neotest/nvim-nio.git" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Rust: CodeLLDB adapter via Mason
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
					args = { "--port", "${port}" },
				},
			}

			dap.configurations.rust = {
				{
					name = "Debug",
					type = "codelldb",
					request = "launch",
					program = function()
						local metadata = vim.fn.system("cargo metadata --format-version 1 --no-deps")
						local metadata_json = vim.fn.json_decode(metadata)
						local target_dir = metadata_json["target_directory"]
						local crate_name = metadata_json["packages"][1]["name"]
						return target_dir .. "/debug/" .. crate_name
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}

			-- Keymaps
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
			vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
		end,
	},
}
