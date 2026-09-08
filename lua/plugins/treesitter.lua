-- The `master` branch is frozen and its README states Neovim 0.12 is not supported; it also caps
-- tree-sitter-cli at 0.25.x while mason ships 0.26.x. `main` is the rewrite: it has no module
-- system, so highlighting and indentation are wired up here by hand.
local PARSERS = {
	"rust",
	"lua",
	"toml",
	"json",
	"markdown",
	"markdown_inline",
	"yaml",
	"bash", -- both requested by noice for cmdline highlighting
	"regex",
}

return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false, -- main does not support lazy-loading
	build = ":TSUpdate",
	-- parsers are compiled with the tree-sitter CLI, which lives in mason's bin dir; mason
	-- prepends that to $PATH when it loads, so it has to load first
	dependencies = { "mason-org/mason.nvim" },
	config = function()
		local ts = require("nvim-treesitter")
		ts.setup()

		local installed = ts.get_installed()
		local missing = vim.tbl_filter(function(lang)
			return not vim.tbl_contains(installed, lang)
		end, PARSERS)
		if #missing > 0 then
			ts.install(missing)
		end

		-- replaces master's `highlight = { enable = true }` / `indent = { enable = true }`
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match)
				if not lang or not vim.tbl_contains(PARSERS, lang) then
					return
				end

				-- core already starts treesitter for markdown and lua; start() replaces any
				-- existing highlighter, so this is safe either way. Fails harmlessly while a
				-- parser is still being installed.
				if not pcall(vim.treesitter.start, ev.buf, lang) then
					return
				end

				-- indents.scm ships with the plugin, never with core
				vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
