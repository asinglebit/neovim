return {
	{
		"ThePrimeagen/harpoon",
		lazy = false,
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local mark = require("harpoon.mark")
			local ui = require("harpoon.ui")

			-- Add current file to Harpoon list
			vim.keymap.set("n", "<leader>a", mark.add_file, { desc = "Harpoon > Add" })

			-- Toggle Harpoon quick menu
			vim.keymap.set("n", "<leader>h", ui.toggle_quick_menu, { desc = "Harpoon > Toggle" })

			-- Jump to files (1-4)
			vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon > Jump 1" })
			vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon > Jump 2" })
			vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon > Jump 3" })
			vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon > Jump 4" })
		end,
	},
}
