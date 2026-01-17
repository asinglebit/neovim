return {
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"*", -- Highlight all filetypes
				css = { rgb_fn = true }, -- Enable `rgb(...)` functions in CSS
				html = { names = true }, -- Enable color names like `red`
			}, {
				-- Additional options
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				names = true, -- "Name" colors (like Blue)
				rgb_fn = true, -- CSS rgb() functions
				hsl_fn = true, -- CSS hsl() functions
				css = true, -- Enable all CSS features
				css_fn = true, -- Enable all CSS functions
				tailwind = true, -- Enable tailwind colors
			})
		end,
	},
}
