-- lazy.nvim pulls a colorscheme plugin in on ColorSchemePre, so none of these load at startup
return {
	{ "navarasu/onedark.nvim", lazy = true, opts = { style = "warmer" } },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "folke/tokyonight.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "gbprod/nord.nvim", lazy = true },
	{ "neanias/everforest-nvim", lazy = true },
	{ "Mofiqul/dracula.nvim", lazy = true },
	{ "nyoom-engineering/oxocarbon.nvim", lazy = true },
}
