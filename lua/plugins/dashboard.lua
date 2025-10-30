return {
	{
		"goolord/alpha-nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Set header (ASCII art)
			dashboard.section.header.val = {
				"             .::::..            ",
				"        ^?5GBGGP5555YJ7~.       ",
				"     ^YB&BY!^.      .:~7J?~     ",
				"   ^P&@#!                :!?^   ",
				"  ?&&&&?                   .77  ",
				" Y&&##&P:                    ~? ",
				"!&######BY7!!~:               !!",
				"P#############BGJ:             J",
				"G################B!         .:!5",
				"5#BBBBBBBBBBBBBBB#B^     :JPBB#5",
				"!#BBBBBBBBBBBBBBBBBBJ!~!JB#BBBB~",
				" ?BBBBBBBBBBBBBBBBBBBBBBBBBBBB? ",
				"  7GBBBBBBBBBBBBBBBBBBBBBBBBG7  ",
				"   ^YGBBGGGGGGGGGGGGGGGGBBGY:   ",
				"     :?5GBBBGGGGGGGGBBBG5?:     ",
				"        :!?Y5PPPPPP5Y?!:        ",
				"             ......             ",
			}

			-- Buttons
			dashboard.section.buttons.val = {
				dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
				dashboard.button("r", "  Recent Files", ":Telescope oldfiles <CR>"),
				dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
				dashboard.button("p", "  Projects", ":Telescope projects <CR>"),
				dashboard.button("q", "  Quit", ":qa<CR>"),
			}

			-- Footer
			dashboard.section.footer.val = ""

			-- **Dynamically calculate top padding to center vertically**
			local function get_padding()
				local height = vim.fn.winheight(0)
				local content_height = #dashboard.section.header.val
					+ #dashboard.section.buttons.val
					+ #dashboard.section.footer.val
					+ 4 -- spacing between sections
				return math.max(0, math.floor((height - content_height) / 2))
			end

			dashboard.config.layout = {
				{ type = "padding", val = get_padding() },
				dashboard.section.header,
				{ type = "padding", val = 5 },
				dashboard.section.buttons,
				{ type = "padding", val = 1 },
				dashboard.section.footer,
			}

			alpha.setup(dashboard.config)
		end,
	},
}
