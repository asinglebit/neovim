return {
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
					on_attach = function(client, bufnr)
						local opts = { buffer = bufnr, silent = true }

						vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
						vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
						vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
						vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					end,

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

	-- LSP for TypeScript, Go, Biome
	{
		"hrsh7th/cmp-nvim-lsp",
		config = function()
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_nvim_lsp.default_capabilities()
			local mason_bin = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/")

			-- ==============================
			-- TypeScript / JavaScript LSP
			-- ==============================
			vim.lsp.config("ts_ls", {
				name = "tsserver",
				cmd = { mason_bin .. "typescript-language-server", "--stdio" },
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
					javascript = { format = { enable = true } },
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

			-- ==============================
			-- Go LSP
			-- ==============================
			vim.lsp.config("gopls", {
				cmd = { mason_bin .. "gopls" },
				filetypes = { "go", "gomod", "gowork", "gotmpl" },
				root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
				capabilities = capabilities,
				settings = {
					gopls = {
						gofumpt = true,
						analyses = { unusedparams = true, shadow = true },
						staticcheck = true,
					},
				},
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})
			vim.lsp.enable("gopls")

			-- ==============================
			-- Lua LSP (for Neovim configs)
			-- ==============================
			vim.lsp.config("lua_ls", {
				cmd = { mason_bin .. "lua-language-server" },
				filetypes = { "lua" },
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" }, -- Neovim uses LuaJIT
						diagnostics = { globals = { "vim" } }, -- recognize vim global
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true), -- Neovim runtime files
							checkThirdParty = false,
						},
						telemetry = { enable = false },
					},
				},
				on_attach = function(client, bufnr)
					local opts = { buffer = bufnr, silent = true }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			vim.lsp.enable("lua_ls")

			-- ==============================
			-- Biome LSP
			-- ==============================
			local function on_attach_biome(client, bufnr)
				local opts = { buffer = bufnr, silent = true }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.code_action({
							context = { only = { "source.fixAll.biome" }, diagnostics = {} },
							apply = true,
						})
					end,
				})
			end

			vim.lsp.config("biome", {
				cmd = { mason_bin .. "biome", "lsp-proxy" },
				filetypes = {
					"htmlangular",
					"html",
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"css",
					"scss",
				},
				root_markers = {
					".eslintrc",
					".eslintrc.js",
					".eslintrc.cjs",
					".eslintrc.yaml",
					".eslintrc.yml",
					".eslintrc.json",
					"eslint.config.js",
					"eslint.config.mjs",
					"eslint.config.cjs",
					"eslint.config.ts",
					"eslint.config.mts",
					"eslint.config.cts",
					"biome.json",
					"package.json",
					".git",
				},
				on_attach = on_attach_biome,
			})
			vim.lsp.enable("biome")
		end,
	},
}
