local M = {}

-- section a per mode: { background, foreground }
local MODES = {
	normal = { "vscGreen" },
	insert = { "vscBlue" },
	visual = { "vscOrange" },
	command = { "vscBlueGreen" },
	terminal = { "vscYellowOrange" },
	replace = { "vscPink" },
	inactive = { "grey_700", "grey_300" },
}

function M.opts()
	local colors = require("theme.palette").current()

	local theme = {}
	for mode, accent in pairs(MODES) do
		theme[mode] = {
			a = { fg = colors[accent[2]] or colors.grey_900, bg = colors[accent[1]], gui = "bold" },
			b = { fg = colors.grey_400, bg = colors.grey_800 },
			c = { fg = colors.grey_500, bg = colors.grey_900 },
			x = { fg = colors.grey_500, bg = colors.grey_900 },
			y = { fg = colors.grey_400, bg = colors.grey_800 },
			z = { fg = colors.grey_300, bg = colors.grey_700 },
		}
	end

	return {
		options = {
			globalstatus = true,
			theme = theme,
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
			},
		},
	}
end

return M
