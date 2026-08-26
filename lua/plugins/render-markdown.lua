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
		config = function(_, opts)
			local colors = require("theme.colors")
			local hl = vim.api.nvim_set_hl

			-- RenderMarkdownH1..H6 link to these; the Diff* background defaults are far too loud
			hl(0, "@markup.heading.1.markdown", { fg = colors.vscBlue, bold = true })
			hl(0, "@markup.heading.2.markdown", { fg = colors.vscOrange, bold = true })
			hl(0, "@markup.heading.3.markdown", { fg = colors.vscYellow, bold = true })
			hl(0, "@markup.heading.4.markdown", { fg = colors.vscGreen, bold = true })
			hl(0, "@markup.heading.5.markdown", { fg = colors.vscBlueGreen, bold = true })
			hl(0, "@markup.heading.6.markdown", { fg = colors.vscPink, bold = true })

			hl(0, "RenderMarkdownH1Bg", { bg = colors.grey_800 })
			hl(0, "RenderMarkdownH2Bg", { bg = colors.grey_850 })
			hl(0, "RenderMarkdownH3Bg", { bg = colors.grey_875 })
			hl(0, "RenderMarkdownH4Bg", { bg = colors.grey_875 })
			hl(0, "RenderMarkdownH5Bg", { bg = colors.grey_875 })
			hl(0, "RenderMarkdownH6Bg", { bg = colors.grey_875 })

			hl(0, "RenderMarkdownBullet", { fg = colors.vscGray })
			hl(0, "RenderMarkdownLink", { fg = colors.vscLightBlue, underline = true })
			hl(0, "RenderMarkdownTableHead", { fg = colors.vscBlueGreen, bold = true })

			require("render-markdown").setup(opts)
		end,
	},
}
