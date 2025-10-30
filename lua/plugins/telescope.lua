return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- optional but recommended for icons
			"nvim-telescope/telescope-fzf-native.nvim", -- optional for faster sorting
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					file_ignore_patterns = { "node_modules", ".git/" },
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-q>"] = actions.send_to_qflist,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = {
						hidden = true, -- show dotfiles
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})

			-- Load FZF extension if installed
			pcall(telescope.load_extension, "fzf")

			-- Optional keymaps
			vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
			vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
			vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
			vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make", -- compile native C extension
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
}
