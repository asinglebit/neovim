return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false, -- force load on startup
	branch = "master",
	build = ":TSUpdate",
	opts = {
		ensure_installed = { "rust", "lua", "toml", "json" },
		highlight = { enable = true },
		indent = { enable = true },
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
