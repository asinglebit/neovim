-- catgoose's fork; norcalli's was last touched in 2021. Same feature set, plus a single-table
-- options shape and awareness of 0.12's textDocument/documentColor.
return {
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			filetypes = {
				"*",
				css = { user_default_options = { rgb_fn = true } }, -- rgb(...) in CSS
				html = { user_default_options = { names = true } }, -- colour names like `red`
			},
			user_default_options = {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" colors (like Blue)
				rgb_fn = true, -- CSS rgb() functions
				hsl_fn = true, -- CSS hsl() functions
				css = true, -- Enable all CSS features
				css_fn = true, -- Enable all CSS functions
				tailwind = true, -- Enable tailwind colors
			},
		},
	},
}
