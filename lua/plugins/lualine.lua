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
						a = { fg = colors.grey_900, bg = colors.green, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					visual = {
						a = { fg = colors.grey_900, bg = colors.yellow, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					insert = {
						a = { fg = colors.grey_900, bg = colors.blue, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					command = {
						a = { fg = colors.grey_900, bg = colors.teal, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					terminal = {
						a = { fg = colors.grey_900, bg = colors.purple, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					replace = {
						a = { fg = colors.grey_900, bg = colors.red, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
					inactive = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
						x = { fg = colors.grey_500, bg = colors.grey_900 },
						y = { fg = colors.grey_400, bg = colors.grey_800 },
						z = { fg = colors.grey_300, bg = colors.grey_700 },
					},
				}
			},
			sections = {
				lualine_a = { "mode" }, -- Vim mode as word
				lualine_b = { "branch" }, -- Git branch
				lualine_c = { "filename" }, -- file name
				lualine_x = { 
					{"encoding", colored = false}, 
					{"fileformat", colored = false}, 
					{"filetype", colored = false}
				},
				lualine_y = { "progress", }, -- file percentage
				lualine_z = {
					"location",
					{
						"os.date('%H:%M')",
						fmt = function(str)
							return str
						end,
					},
				}, -- time
			},
		}
	end,
}
