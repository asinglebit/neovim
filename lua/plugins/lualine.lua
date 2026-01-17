return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional for file icons
	opts = function()
		local colors = require("theme.colors")

		return {
			options = {
				globalstatus = true,
				-- disabled_filetypes = { statusline = { "alpha", "dashboard" } },
				theme = {
					normal = {
						a = { fg = colors.grey_900, bg = colors.vscGreen, gui = "bold" },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					visual = {
						a = { fg = colors.grey_900, bg = colors.vscOrange, gui = "bold" },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					insert = {
						a = { fg = colors.grey_900, bg = colors.vscBlue, gui = "bold" },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					command = {
						a = { fg = colors.grey_900, bg = colors.vscBlueGreen, gui = "bold" },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					terminal = {
						a = { fg = colors.grey_900, bg = colors.vscYellowOrange, gui = "bold" },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					replace = {
						a = { fg = colors.grey_900, bg = colors.vscPink, gui = "bold" },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					inactive = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = "bold" },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
				},
			},
			sections = {
				lualine_a = { "mode" }, -- Vim mode as word
				lualine_b = { "branch" }, -- Git branch
				lualine_c = { "filename" }, -- file name
				lualine_x = {
					{ "encoding", colored = false },
					{ "fileformat", colored = false },
					{ "filetype", colored = false },
				},
				lualine_y = { "progress" }, -- file percentage
				lualine_z = {
					"location",
				}, -- time
			},
		}
	end,
}
