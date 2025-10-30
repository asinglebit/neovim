return {
	{
		"goolord/alpha-nvim",
		lazy = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Contribution chart

			local function get_contribution_chart(days)
				days = days or 200
				local handle = io.popen(
					'git log --since="' .. days .. ' days ago" --date=short --pretty=format:"%ad" 2>/dev/null'
				)
				if not handle then return { " No git data" } end

				local commits = {}
				for line in handle:lines() do
					commits[line] = (commits[line] or 0) + 1
				end
				handle:close()

				-- map commit counts to unicode symbols (light → heavy)
				local symbols = { "· ", "• ", "● ", "⬤ ", "⯀ " }
				local chart = {}

				for i = days, 1, -1 do
					local date = os.date("%Y-%m-%d", os.time() - (i * 86400))
					local count = commits[date] or 0
					local symbol
					if count == 0 then
						symbol = "  "
					elseif count < 2 then
						symbol = symbols[1]
					elseif count < 5 then
						symbol = symbols[2]
					elseif count < 10 then
						symbol = symbols[3]
					elseif count < 20 then
						symbol = symbols[4]
					else
						symbol = symbols[5]
					end
					table.insert(chart, symbol)
				end

				-- Render horizontally, grouping 7-day columns
				local rows = { "", "", "", "", "", "", "" }
				for i = 1, #chart do
					local row = (i - 1) % 7 + 1
					rows[row] = rows[row] .. chart[i]
				end

				-- Trim leading and trailing spaces
				for i, row in ipairs(rows) do
					rows[i] = row:match("^%s*(.-)%s*$") or ""
				end

				return rows
			end

			-- Get recent git commits from the current repo
			local function get_recent_commits(n)
				n = n or 5
				local commits = {}
				local handle = io.popen('git --no-pager log -n ' .. n .. ' --pretty=format:"%h - %s (%cr)" 2>/dev/null')
				if handle then
					for line in handle:lines() do
						table.insert(commits, line)
					end
					handle:close()
				end
				if #commits == 0 then
					table.insert(commits, "")
				end
				return commits
			end

			local function trim_with_ellipsis(str, max_width)
				local str_width = vim.fn.strdisplaywidth(str)
				if str_width <= max_width then
					return str
				else
					local trimmed = ""
					local width = 0
					for c in str:gmatch(".") do
						local char_width = vim.fn.strdisplaywidth(c)
						if width + char_width + 1 > max_width then  -- +1 for ellipsis
							break
						end
						trimmed = trimmed .. c
						width = width + char_width
					end
					return trimmed .. "…"
				end
			end

			-- Fixed width function
			local function fixed_width(label, width)
				local len = vim.fn.strdisplaywidth(label)
				if len < width then
					return label .. string.rep(" ", width - len)
				else
					return label
				end
			end
			
			-- Check if current directory is a git repository
			local function is_git_repo()
				local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
				if not handle then return false end
				local result = handle:read("*a")
				handle:close()
				return result:match("true") ~= nil
			end

			-- Set header (ASCII art)
			dashboard.section.header.opts = { hl = "DashboardChart", position = "center" }

			-- Set dashboard header
			if is_git_repo() then
				dashboard.section.header.val = get_contribution_chart(360)
			else
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
			end

			local padding = 60
			-- Buttons
			dashboard.section.buttons.opts = {
				hl = "DashboardCommits",        -- Highlight for the button label
				hl_shortcut = "Keyword" -- Highlight for the shortcut key (the first argument)
			}
			dashboard.section.buttons.val = {
				dashboard.button("f", fixed_width("⌕  Find File", padding), ":Telescope find_files <CR>"),
				dashboard.button("r", fixed_width("  Recent Files", padding), ":Telescope oldfiles <CR>"),
				dashboard.button("n", fixed_width("  New File", padding), ":ene <BAR> startinsert <CR>"),
				dashboard.button("p", fixed_width("  Projects", padding), ":Telescope project <CR>"),
				dashboard.button("q", fixed_width("⨯  Quit", padding), ":qa<CR>"),
			}

			-- Footer
			dashboard.section.footer.opts = { hl = "DashboardCommits", position = "center" }

			local max_width = 60
			local commits = get_recent_commits(5)
			for i, commit in ipairs(commits) do
				commits[i] = trim_with_ellipsis(commit, max_width)
			end
			dashboard.section.footer.val = commits
			

			-- Dynamically calculate top padding to center vertically
			local function get_padding()
				local height = vim.fn.winheight(0)
				local content_height = #dashboard.section.header.val
					+ #dashboard.section.buttons.val
					+ #dashboard.section.footer.val
					+ 8 -- spacing between sections
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
