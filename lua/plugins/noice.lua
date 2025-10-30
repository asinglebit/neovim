return {
	{
		"folke/noice.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim", -- required for floating UI
			"rcarriga/nvim-notify", -- optional, nice notification backend
		},
		lazy = false,
		config = function()
			require("noice").setup({
				-- Enable Noice for messages, command line, popupmenu
				cmdline = {
					view = "cmdline_popup", -- show command line in floating popup
					format = {
						cmdline = { pattern = "^:", icon = " " },
						search_down = { icon = " " },
						search_up = { icon = " " },
					},
					position = {
						row = "10%", -- vertical position (10% from top)
						col = "50%", -- horizontal center
					},
					size = {
						width = "80%", -- width of popup
						height = 1, -- only one line tall
					},
				},
				messages = {
					view = "mini", -- display messages minimally
				},
				popupmenu = {
					enabled = true, -- use noice popupmenu
				},
				-- Optional: presets for nicer UI
				presets = {
					bottom_search = false, -- disable bottom command-line search
					command_palette = true, -- nicer command palette
					long_message_to_split = true,
				},
			})

			-- Optional: set notify as the notification handler
			vim.notify = require("notify")
		end,
	},
}
