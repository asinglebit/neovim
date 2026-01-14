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

		    -- Go: LSP via gopls
		vim.lsp.config("gopls", {
		  cmd = { vim.fn.stdpath("data") .. "/mason/bin/gopls" },
		  filetypes = { "go", "gomod", "gowork", "gotmpl" },
		  root_dir = vim.fs.root(0, { "go.work", "go.mod", ".git" }),
		  capabilities = capabilities,

		  settings = {
			gopls = {
			  gofumpt = true,
			  analyses = {
				unusedparams = true,
				shadow = true,
			  },
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

		end,
	},
}
