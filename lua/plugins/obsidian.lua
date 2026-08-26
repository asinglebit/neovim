return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- latest release
		ft = "markdown",
		cmd = "Obsidian",
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Switch note" },
			{ "<leader>og", "<cmd>Obsidian search<cr>", desc = "Grep vault" },
			{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
			{ "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Tags" },
			{ "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
			{ "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Links in note" },
			{ "<leader>oc", "<cmd>Obsidian toc<cr>", desc = "Table of contents" },
			{ "<leader>od", "<cmd>Obsidian today<cr>", desc = "Today's note" },
			{ "<leader>oD", "<cmd>Obsidian dailies<cr>", desc = "Daily notes" },
			{ "<leader>ox", "<cmd>Obsidian toggle_checkbox<cr>", desc = "Toggle checkbox" },
			{ "<leader>oi", "<cmd>Obsidian paste_img<cr>", desc = "Paste image" },
			{ "<leader>oe", ":Obsidian extract_note<cr>", mode = "v", desc = "Extract to new note" },
			{ "<leader>ok", ":Obsidian link<cr>", mode = "v", desc = "Link selection" },
		},
		opts = function()
			local colors = require("theme.colors")

			return {
				legacy_commands = false,
				workspaces = {
					{ name = "payperpaper", path = "~/projects/personal/payperpaper/docs" },
				},
				picker = { name = "telescope.nvim" },

				-- docs/ is git-tracked with hand-written tags and aliases
				frontmatter = { enabled = false },

				-- vault filenames are the title verbatim, e.g. "Wages and Banking.md"
				note_id_func = function(title)
					if title and vim.trim(title) ~= "" then
						return vim.trim(title)
					end
					return require("obsidian.builtin").zettel_id()
				end,

				daily_notes = { folder = "Daily" },
				attachments = { folder = "assets" },
				checkbox = { order = { " ", "x" } },

				-- render-markdown.nvim owns rendering; detection is runtimepath-based, so be explicit
				ui = { enable = false },
			}
		end,
	},
}
