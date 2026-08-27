return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		version = "*", -- latest release
		ft = "markdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>or", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle rendering" },
		},
		opts = {
			preset = "obsidian", -- render in every mode, like Obsidian's live preview
			heading = { sign = false, width = "block", right_pad = 2 },
			code = { sign = false, width = "block", left_pad = 2, right_pad = 2 },
			pipe_table = { preset = "round" },
			-- the vault has no HTML and no maths; <u32>/<Vec3> are Rust generics in code spans
			html = { enabled = false },
			latex = { enabled = false },
		},
	},
}
