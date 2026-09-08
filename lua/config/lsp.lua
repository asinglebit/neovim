-- ==============================
-- LSP
-- ==============================
-- Servers are declared by hand with vim.lsp.config()/vim.lsp.enable(); nvim-lspconfig is not
-- installed. This lives in config/ rather than hanging off a plugin's `config` function, so
-- swapping the completion engine does not take the LSP setup with it.
local mason_bin = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/")

-- Neovim 0.12 ships these LSP mappings globally: gra (code action), gri (implementation),
-- grn (rename), grr (references), grt (type definition), grx (run codelens), gO (document
-- symbols), i_CTRL-S (signature help), and K for hover on attach. Only `gd` has no built-in
-- equivalent, so only `gd` is added -- plus the two leader aliases this config has always had.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(ev)
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buf = ev.buf, silent = true, desc = desc })
		end
		map("gd", vim.lsp.buf.definition, "Go to definition")
		map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		map("<leader>ca", vim.lsp.buf.code_action, "Code action")
	end,
})

-- One place for capabilities, inherited by every server -- biome included, which previously
-- missed out because each server was given its own copy.
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilities = vim.tbl_deep_extend("force", capabilities, cmp_nvim_lsp.default_capabilities())
end
vim.lsp.config("*", { capabilities = capabilities })

-- ==============================
-- TypeScript / JavaScript
-- ==============================
vim.lsp.config("ts_ls", {
	cmd = { mason_bin .. "typescript-language-server", "--stdio" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	-- root_markers, not root_dir: a root_dir string is resolved once, when this file runs,
	-- against whatever buffer is current, and then frozen for the whole session
	root_markers = { "tsconfig.json", "package.json", ".git" },
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
})
vim.lsp.enable("ts_ls")

-- ==============================
-- Go
-- ==============================
vim.lsp.config("gopls", {
	cmd = { mason_bin .. "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	settings = {
		gopls = {
			gofumpt = true,
			analyses = { unusedparams = true, shadow = true },
			staticcheck = true,
		},
	},
})
vim.lsp.enable("gopls")

-- ==============================
-- Lua (for Neovim configs)
-- ==============================
vim.lsp.config("lua_ls", {
	cmd = { mason_bin .. "lua-language-server" },
	filetypes = { "lua" },
	-- without a root, lua_ls runs single-file and never indexes across the config
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".stylua.toml", ".git" },
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
})
vim.lsp.enable("lua_ls")

-- ==============================
-- Biome
-- ==============================
vim.lsp.config("biome", {
	cmd = { mason_bin .. "biome", "lsp-proxy" },
	filetypes = {
		"htmlangular",
		"html",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
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
})
vim.lsp.enable("biome")

-- Biome's fixAll on save. Registered per buffer when Biome attaches, rather than from a shared
-- augroup that each new attach would clear out from under the other buffers.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_biome_fixall", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client or client.name ~= "biome" or vim.b[ev.buf].biome_fixall then
			return
		end
		vim.b[ev.buf].biome_fixall = true

		vim.api.nvim_create_autocmd("BufWritePre", {
			buf = ev.buf,
			callback = function()
				vim.lsp.buf.code_action({
					context = { only = { "source.fixAll.biome" }, diagnostics = {} },
					apply = true,
				})
			end,
		})
	end,
})
