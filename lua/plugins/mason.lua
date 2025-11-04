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
				ensure_installed = { "rust_analyzer", "ts_ls", "angularls" },
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
	{
		"hrsh7th/cmp-nvim-lsp", -- for completion capabilities
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- TypeScript: LSP via tsserver

			vim.lsp.config("ts_ls", {
				name = "tsserver",
    			cmd = { vim.fn.stdpath("data") .. "/mason/bin/typescript-language-server", "--stdio" },
				capabilities = capabilities,
				filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
				root_dir = vim.fs.root(0, { "tsconfig.json", "package.json", ".git" }),
				settings = {
					typescript = {
						format = { enable = true },
						suggest = { completeFunctionCalls = true },
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayVariableTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
					javascript = {
						format = { enable = true },
					},
				},
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				end,
			})
			vim.lsp.enable("ts_ls")

			-- Angular: LSP via angularls

			local function get_probe_dir(root_dir)
				local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
				return project_root and (project_root .. "/node_modules") or ""
			end
		
			local function get_angular_core_version(root_dir)
				local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])
				if not project_root then
					return ""
				end
				local package_json = project_root .. "/package.json"
				if not vim.loop.fs_stat(package_json) then
					return ""
				end
				local contents = io.open(package_json):read("*a")
				local json = vim.json.decode(contents)
				if not json.dependencies then
					return ""
				end
				local angular_core_version = json.dependencies["@angular/core"]
				angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")
				return angular_core_version
			end
		
			local project_root = vim.fs.root(0, { "angular.json", "nx.json", "package.json", ".git" }) or vim.fn.getcwd()
			local default_probe_dir = get_probe_dir(project_root)
			local default_angular_core_version = get_angular_core_version(project_root)
			local ngserver = vim.fn.stdpath("data") .. "/mason/bin/ngserver"
		
			vim.lsp.config("angularls", {
				cmd = {
					ngserver,
					"--stdio",
					"--tsProbeLocations",
					default_probe_dir,
					"--ngProbeLocations",
					default_probe_dir,
					"--angularCoreVersion",
					default_angular_core_version,
				},
				filetypes = {
					"html",
					"htmlangular",
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				capabilities = capabilities,
				root_dir = vim.fs.root(0, { "angular.json", "package.json", ".git" }),
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				end,
			})
			vim.lsp.enable("angularls")
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
