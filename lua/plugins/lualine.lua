return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional for file icons
	opts = function()
		return require("theme.lualine").opts()
	end,
}
