local function restore_previous_file()
  local oldfiles = vim.v.oldfiles
  if #oldfiles > 0 then
    vim.cmd("edit " .. oldfiles[1])
  else
    print("No previous file found")
  end
end

return {

	-- Dressing.nvim (optional, improves UI)
	{
		"stevearc/dressing.nvim",
		lazy = true,
	},

	-- Web Devicons (optional, adds icons support)
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
	},

	-- Mini.icons (optional, adds icons for mappings)
	{
		"echasnovski/mini.icons",
		version = false, -- optional
	},

	-- WhichKey
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			icons = {
				breadcrumb = ">",  -- remove parent → arrows
				separator  = "", -- remove → between key & description
				group      = "",  -- remove the + or any group icons
			},
			layout = { align = "center" },
			win = {
				padding = { 3, 3 },
				wo = { winblend = 0 },
				title = nil,
			},
			spec = {
				-- Debug group
				{ "<leader>d", group = "Debug", icon = ""  },
				{ "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle Breakpoint", icon = ""  },
				{ "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", desc = "Toggle DAP UI", icon = ""  },

				-- Buffers
				{ "<leader>b", group = "Buffers", icon = "" },
				{ "<leader>bb", ":Telescope buffers<CR>", desc = "List Buffers", icon = ""  },
				{ "<leader>bd", ":bdelete<CR>", desc = "Delete Buffer", icon = ""  },
				{ "<leader>bn", ":bnext<CR>", desc = "Next Buffer", icon = ""  },
				{ "<leader>bp", ":bprevious<CR>", desc = "Previous Buffer", icon = ""  },

				-- Windows
				{ "<leader>w", group = "Windows", icon = ""  },
				{ "<leader>ws", ":split<CR>", desc = "Horizontal Split", icon = ""  },
				{ "<leader>wv", ":vsplit<CR>", desc = "Vertical Split", icon = ""  },
				{ "<leader>wc", ":close<CR>", desc = "Close Window", icon = ""  },
				{ "<leader>wo", "<C-w>o", desc = "Close Other Windows", icon = ""  },
				{ "<leader>wh", "<C-w>h", desc = "Move to Left Window", icon = ""  },
				{ "<leader>wj", "<C-w>j", desc = "Move to Lower Window", icon = ""  },
				{ "<leader>wk", "<C-w>k", desc = "Move to Upper Window", icon = ""  },
				{ "<leader>wl", "<C-w>l", desc = "Move to Right Window", icon = ""  },

				-- Find
				{ "<leader>f", group = "Find", icon = ""  },
				{ "<leader>ff", ":Telescope find_files<CR>", desc = "Find File", icon = ""  },
				{ "<leader>fg", ":Telescope live_grep<CR>", desc = "Live Grep", icon = ""  },
				{ "<leader>fr", ":Telescope oldfiles<CR>", desc = "Recent Files", icon = ""  },
				
				-- LazyVim
				{ "<leader>l", group = "LazyVim", icon = ""  },
				{ "<leader>li", ":Lazy install<CR>", desc = "Install Plugins", icon = ""  },
				{ "<leader>ls", ":Lazy sync<CR>", desc = "Sync Plugins", icon = ""  },
				{ "<leader>lu", ":Lazy update<CR>", desc = "Update Plugins", icon = ""  },

				-- Quit/Session
				{ "<leader>q", group = "Quit/Session", icon = ""  },
				{ "<leader>qq", ":qa<CR>", desc = "Quit Neovim", icon = ""  },
				{ "<leader>qs", ":w<CR>", desc = "Save File", icon = ""  },

				-- Telescope
				{ "<leader>r", ":Telescope oldfiles<CR>", desc = "Telescope > Restore previous", icon = ""  },

				-- Neotree
				{ "<leader>e", "<Cmd>Neotree toggle<CR>", desc = "Neotree > Toggle", icon = "" }
			}
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)  -- set up WhichKey with your opts
  end,
}
