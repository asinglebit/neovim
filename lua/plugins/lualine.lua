return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional for file icons
	opts = function()
		local colors = require("themes.colors")

		return {
			options = {
				globalstatus = true,
				-- disabled_filetypes = { statusline = { "alpha", "dashboard" } },
				theme = {
					normal = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
					},
					visual = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
					},
					insert = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
					},
					command = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
					},
					terminal = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
					},
					inactive = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
					},
					replace = {
						a = { fg = colors.grey_300, bg = colors.grey_700, gui = 'bold' },
						b = { fg = colors.grey_400, bg = colors.grey_800 },
						c = { fg = colors.grey_500, bg = colors.grey_900 },
					}
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
