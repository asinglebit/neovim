return {
  {
    "goolord/alpha-nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha_ok, alpha = pcall(require, "alpha")
      if not alpha_ok then
        vim.notify("alpha-nvim not found", vim.log.levels.WARN)
        return
      end

      local dashboard_ok, dashboard = pcall(require, "alpha.themes.dashboard")
      if not dashboard_ok then
        vim.notify("alpha-nvim dashboard theme not found", vim.log.levels.WARN)
        return
      end

      -- Fixed width helper
      local function pad_label(label, width)
        local len = vim.fn.strdisplaywidth(label)
        if len < width then
          return label .. string.rep(" ", width - len)
        else
          return label
        end
      end

      -- Header (ASCII art)
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
        "                                ",
        "                                ",
        "                                ",
      }
      dashboard.section.header.opts = { hl = "DashboardChart", position = "center" }

      -- Buttons helper: replace `fixed_width` with a simple helper
      local function make_button(shortcut, text, command)
        return dashboard.button(shortcut, text, command)
      end

      local padding = 60
      dashboard.section.buttons.opts = {
        hl = "DashboardCommits",
        hl_shortcut = "Keyword",
      }

      dashboard.section.buttons.val = {
		  make_button("f", pad_label("⌕  Find File", padding), ":Telescope find_files <CR>"),
		  make_button("r", pad_label("  Recent Files", padding), ":Telescope oldfiles <CR>"),
		  make_button("n", pad_label("  New File", padding), ":ene <BAR> startinsert <CR>"),
		  make_button("p", pad_label("  Projects", padding), ":Telescope project <CR>"),
		  make_button("q", pad_label("⨯  Quit", padding), ":qa<CR>"),
      }
      -- Footer
      dashboard.section.footer.opts = { hl = "DashboardCommits", position = "center" }

      -- Dynamically calculate padding to center vertically
      local function get_padding()
        local height = vim.fn.winheight(0)
        local content_height =
          #dashboard.section.header.val +
          #dashboard.section.buttons.val +
          #dashboard.section.footer.val
        return math.max(0, math.floor((height - content_height) / 2))
      end

      dashboard.config.layout = {
        { type = "padding", val = get_padding() },
        dashboard.section.header,
        { type = "padding", val = 1 },
        dashboard.section.buttons,
        { type = "padding", val = 1 },
        dashboard.section.footer,
      }

      alpha.setup(dashboard.config)
    end,
  },
}

