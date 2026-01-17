local colors = require("theme.colors")

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, but recommended for file icons :contentReference[oaicite:1]{index=1}
	},
	keys = {
		{ "<leader>e", "<Cmd>Neotree toggle<CR>", desc = "Neotree > Toggle" },
	},
	lazy = false,
	opts = {
		close_if_last_window = true,
		popup_border_style = "NC",
		clipboard = {
			sync = "none",
		},
		enable_git_status = true,
		enable_diagnostics = true,
		open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
		open_files_using_relative_paths = false,
		sort_case_insensitive = false,
		sort_function = nil,
		default_component_configs = {
			container = {
				enable_character_fade = true,
			},
			indent = {
				indent_size = 2,
				padding = 1,
				with_markers = true,
				indent_marker = "│",
				last_indent_marker = "╰",
				highlight = "NeoTreeIndentMarker",
				with_expanders = nil,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			icon = {
				folder_closed = "",
				folder_open = "",
				folder_empty = "󰜌",
				provider = function(icon, node, state)
					if node.type == "file" or node.type == "terminal" then
						local success, web_devicons = pcall(require, "nvim-web-devicons")
						local name = node.type == "terminal" and "terminal" or node.name
						if success then
							local devicon, hl = web_devicons.get_icon(name)
							icon.text = devicon or icon.text
						end
					end
				end,
				default = "🗋",
				highlight = "NeoTreeFileIcon",
				use_filtered_colors = true,
			},
			modified = {
				symbol = "*",
				highlight = "NeoTreeModified",
			},
			name = {
				trailing_slash = false,
				use_filtered_colors = true,
				use_git_status_colors = false,
				highlight = "NeoTreeFileName",
			},
			git_status = {
				symbols = {
					added = "+",
					modified = "~",
					deleted = "-",
					renamed = "r",
					untracked = "◌",
					ignored = "•",
					unstaged = "○",
					staged = "●",
					conflict = "!",
				},
			},
			file_size = {
				enabled = true,
				width = 12, -- width of the column
				required_width = 64, -- min width of window required to show this column
			},
			type = {
				enabled = true,
				width = 10, -- width of the column
				required_width = 122, -- min width of window required to show this column
			},
			last_modified = {
				enabled = true,
				width = 20, -- width of the column
				required_width = 88, -- min width of window required to show this column
			},
			created = {
				enabled = true,
				width = 20, -- width of the column
				required_width = 110, -- min width of window required to show this column
			},
			symlink_target = {
				enabled = false,
			},
		},
		commands = {},
		window = {
			position = "left",
			width = 30,
			mapping_options = {
				noremap = true,
				nowait = true,
			},
			mappings = {
				["<space>"] = {
					"toggle_node",
					nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
				},
				["h"] = "close_node", -- collapse folder / go to parent
				["l"] = "open",
				["<2-LeftMouse>"] = "open",
				["<cr>"] = "open",
				["<esc>"] = "cancel", -- close preview or floating neo-tree window
				["P"] = {
					"toggle_preview",
					config = {
						use_float = true,
						use_snacks_image = true,
						use_image_nvim = true,
					},
				},
				["S"] = "open_split",
				["s"] = "open_vsplit",
				-- ["S"] = "split_with_window_picker",
				-- ["s"] = "vsplit_with_window_picker",
				["t"] = "open_tabnew",
				-- ["<cr>"] = "open_drop",
				-- ["t"] = "open_tab_drop",
				["w"] = "open_with_window_picker",
				--["P"] = "toggle_preview", -- enter preview mode, which shows the current node without focusing
				["C"] = "close_node",
				-- ['C'] = 'close_all_subnodes',
				["z"] = "close_all_nodes",
				--["Z"] = "expand_all_nodes",
				--["Z"] = "expand_all_subnodes",
				["a"] = {
					"add",
					config = {
						show_path = "none", -- "none", "relative", "absolute"
					},
				},
				["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
				["d"] = "delete",
				["r"] = "rename",
				["b"] = "rename_basename",
				["y"] = "copy_to_clipboard",
				["x"] = "cut_to_clipboard",
				["p"] = "paste_from_clipboard",
				--["<C-r>"] = "clear_clipboard",
				["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
				-- ["c"] = {
				--  "copy",
				--  config = {
				--    show_path = "none" -- "none", "relative", "absolute"
				--  }
				--}
				["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
				["q"] = "close_window",
				["R"] = "refresh",
				["?"] = "show_help",
				["<"] = "prev_source",
				[">"] = "next_source",
				["i"] = "show_file_details",
				-- ["i"] = {
				--   "show_file_details",
				--   -- format strings of the timestamps shown for date created and last modified (see `:h os.date()`)
				--   -- both options accept a string or a function that takes in the date in seconds and returns a string to display
				--   -- config = {
				--   --   created_format = "%Y-%m-%d %I:%M %p",
				--   --   modified_format = "relative", -- equivalent to the line below
				--   --   modified_format = function(seconds) return require('neo-tree.utils').relative_date(seconds) end
				--   -- }
				-- },
			},
		},
		nesting_rules = {},
		filesystem = {
			filtered_items = {
				visible = false,
				hide_dotfiles = true,
				hide_gitignored = true,
				hide_ignored = true, -- hide files that are ignored by other gitignore-like files
				-- other gitignore-like files, in descending order of precedence.
				ignore_files = {
					".neotreeignore",
					".ignore",
					-- ".rgignore"
				},
				hide_hidden = true, -- only works on Windows for hidden files/directories
				hide_by_name = {
					--"node_modules"
				},
				hide_by_pattern = { -- uses glob style patterns
					--"*.meta",
					--"*/src/*/tsconfig.json",
				},
				always_show = { -- remains visible even if other settings would normally hide it
					--".gitignored",
				},
				always_show_by_pattern = { -- uses glob style patterns
					--".env*",
				},
				never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
					--".DS_Store",
					--"thumbs.db"
				},
				never_show_by_pattern = { -- uses glob style patterns
					--".null-ls_*",
				},
			},
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			group_empty_dirs = false,
			hijack_netrw_behavior = "open_current",
			use_libuv_file_watcher = false,
			window = {
				mappings = {
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["H"] = "toggle_hidden",
					["/"] = "fuzzy_finder",
					["D"] = "fuzzy_finder_directory",
					["#"] = "fuzzy_sorter",
					-- ["D"] = "fuzzy_sorter_directory",
					["f"] = "filter_on_submit",
					["<c-x>"] = "clear_filter",
					["[g"] = "prev_git_modified",
					["]g"] = "next_git_modified",
					["o"] = {
						"show_help",
						nowait = false,
						config = { title = "Order by", prefix_key = "o" },
					},
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["og"] = { "order_by_git_status", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
					-- ['<key>'] = function(state) ... end,
				},
				fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
					["<down>"] = "move_cursor_down",
					["<C-n>"] = "move_cursor_down",
					["<up>"] = "move_cursor_up",
					["<C-p>"] = "move_cursor_up",
					["<esc>"] = "close",
					["<S-CR>"] = "close_keep_filter",
					["<C-CR>"] = "close_clear_filter",
					["<C-w>"] = { "<C-S-w>", raw = true },
					{
						-- normal mode mappings
						n = {
							["j"] = "move_cursor_down",
							["k"] = "move_cursor_up",
							["<S-CR>"] = "close_keep_filter",
							["<C-CR>"] = "close_clear_filter",
							["<esc>"] = "close",
						},
					},
					-- ["<esc>"] = "noop", -- if you want to use normal mode
					-- ["key"] = function(state, scroll_padding) ... end,
				},
			},

			commands = {}, -- Add a custom command or override a global one using the same function name
		},
		buffers = {
			follow_current_file = {
				enabled = true,
				leave_dirs_open = false,
			},
			group_empty_dirs = true,
			show_unloaded = true,
			window = {
				mappings = {
					["d"] = "buffer_delete",
					["bd"] = "buffer_delete",
					["<bs>"] = "navigate_up",
					["."] = "set_root",
					["o"] = {
						"show_help",
						nowait = false,
						config = { title = "Order by", prefix_key = "o" },
					},
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
				},
			},
		},
		git_status = {
			window = {
				position = "float",
				mappings = {
					["A"] = "git_add_all",
					["gu"] = "git_unstage_file",
					["gU"] = "git_undo_last_commit",
					["ga"] = "git_add_file",
					["gr"] = "git_revert_file",
					["gc"] = "git_commit",
					["gp"] = "git_push",
					["gg"] = "git_commit_and_push",
					["o"] = {
						"show_help",
						nowait = false,
						config = { title = "Order by", prefix_key = "o" },
					},
					["oc"] = { "order_by_created", nowait = false },
					["od"] = { "order_by_diagnostics", nowait = false },
					["om"] = { "order_by_modified", nowait = false },
					["on"] = { "order_by_name", nowait = false },
					["os"] = { "order_by_size", nowait = false },
					["ot"] = { "order_by_type", nowait = false },
				},
			},
		},
		sources = { "filesystem", "buffers", "git_status" },

		source_selector = {
			winbar = false, -- show tabs in the window bar
			statusline = true, -- alternatively, could show in statusline
			show_scrolled_off_parent_node = false,
			sources = {
				{ source = "filesystem", display_name = " Files" },
				{ source = "buffers", display_name = " Buffers" },
				{ source = "git_status", display_name = " Git" },
			},
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)

		vim.cmd([[
			highlight NeoTreeRootName gui=bold
		]])
	end,
}
