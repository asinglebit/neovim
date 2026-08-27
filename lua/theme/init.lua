local M = {}

local STATE = vim.fn.stdpath("state") .. "/theme.txt"

-- background is declared on every entry: the derived ramp inverts direction on light schemes
M.registry = {
	{ key = "onedark", label = "Custom  ·  onedark warmer", colorscheme = "onedark", palette = "authored" },

	{ key = "catppuccin-mocha", label = "Catppuccin  ·  Mocha", colorscheme = "catppuccin-mocha" },
	{ key = "catppuccin-macchiato", label = "Catppuccin  ·  Macchiato", colorscheme = "catppuccin-macchiato" },
	{ key = "catppuccin-frappe", label = "Catppuccin  ·  Frappe", colorscheme = "catppuccin-frappe" },
	{ key = "catppuccin-latte", label = "Catppuccin  ·  Latte", colorscheme = "catppuccin-latte", background = "light" },

	{ key = "tokyonight-night", label = "Tokyo Night  ·  Night", colorscheme = "tokyonight-night" },
	{ key = "tokyonight-storm", label = "Tokyo Night  ·  Storm", colorscheme = "tokyonight-storm" },
	{ key = "tokyonight-moon", label = "Tokyo Night  ·  Moon", colorscheme = "tokyonight-moon" },
	{ key = "tokyonight-day", label = "Tokyo Night  ·  Day", colorscheme = "tokyonight-day", background = "light" },

	{ key = "rose-pine-main", label = "Rose Pine  ·  Main", colorscheme = "rose-pine-main" },
	{ key = "rose-pine-moon", label = "Rose Pine  ·  Moon", colorscheme = "rose-pine-moon" },
	{ key = "rose-pine-dawn", label = "Rose Pine  ·  Dawn", colorscheme = "rose-pine-dawn", background = "light" },

	{ key = "gruvbox-dark", label = "Gruvbox  ·  Dark", colorscheme = "gruvbox" },
	{ key = "gruvbox-light", label = "Gruvbox  ·  Light", colorscheme = "gruvbox", background = "light" },

	{ key = "kanagawa-wave", label = "Kanagawa  ·  Wave", colorscheme = "kanagawa-wave" },
	{ key = "kanagawa-dragon", label = "Kanagawa  ·  Dragon", colorscheme = "kanagawa-dragon" },
	{ key = "kanagawa-lotus", label = "Kanagawa  ·  Lotus", colorscheme = "kanagawa-lotus", background = "light" },

	{ key = "nightfox", label = "Nightfox  ·  Night", colorscheme = "nightfox" },
	{ key = "duskfox", label = "Nightfox  ·  Dusk", colorscheme = "duskfox" },
	{ key = "nordfox", label = "Nightfox  ·  Nord", colorscheme = "nordfox" },
	{ key = "terafox", label = "Nightfox  ·  Tera", colorscheme = "terafox" },
	{ key = "carbonfox", label = "Nightfox  ·  Carbon", colorscheme = "carbonfox" },
	{ key = "dayfox", label = "Nightfox  ·  Day", colorscheme = "dayfox", background = "light" },
	{ key = "dawnfox", label = "Nightfox  ·  Dawn", colorscheme = "dawnfox", background = "light" },

	{ key = "nord", label = "Nord", colorscheme = "nord" },

	{ key = "everforest-dark", label = "Everforest  ·  Dark", colorscheme = "everforest" },
	{ key = "everforest-light", label = "Everforest  ·  Light", colorscheme = "everforest", background = "light" },

	{ key = "dracula", label = "Dracula", colorscheme = "dracula" },
	{ key = "dracula-soft", label = "Dracula  ·  Soft", colorscheme = "dracula-soft" },

	{ key = "oxocarbon-dark", label = "Oxocarbon  ·  Dark", colorscheme = "oxocarbon" },
	{ key = "oxocarbon-light", label = "Oxocarbon  ·  Light", colorscheme = "oxocarbon", background = "light" },
}

local function by_key(key)
	for _, entry in ipairs(M.registry) do
		if entry.key == key then
			return entry
		end
	end
end

---The registry entry a bare `:colorscheme` landed on, used only to spot the authored palette.
local function by_colorscheme(name)
	for _, entry in ipairs(M.registry) do
		if entry.colorscheme == name then
			return entry
		end
	end
end

function M.apply(entry, persist)
	vim.o.background = entry.background or "dark"
	local ok, err = pcall(vim.cmd.colorscheme, entry.colorscheme)
	if not ok then
		vim.notify(("theme: %s is unavailable (%s)"):format(entry.label, err), vim.log.levels.WARN)
		return false
	end
	if persist then
		vim.fn.writefile({ entry.key }, STATE)
	end
	return true
end

function M.pick()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	local before = { colorscheme = vim.g.colors_name, background = vim.o.background }
	local restore = true

	local picker = pickers.new({}, {
		prompt_title = "Themes",
		finder = finders.new_table({
			results = M.registry,
			entry_maker = function(entry)
				return { value = entry, display = entry.label, ordinal = entry.label }
			end,
		}),
		sorter = conf.generic_sorter({}),
		attach_mappings = function(bufnr)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				if not selection then
					return
				end
				restore = false
				actions.close(bufnr)
				M.apply(selection.value, true)
			end)
			return true
		end,
	})

	-- telescope's own colorscheme picker previews the same way: wrap selection and teardown
	local close_windows = picker.close_windows
	picker.close_windows = function(status)
		close_windows(status)
		if restore and before.colorscheme then
			vim.o.background = before.background
			pcall(vim.cmd.colorscheme, before.colorscheme)
		end
	end

	local set_selection = picker.set_selection
	picker.set_selection = function(self, row)
		set_selection(self, row)
		local selection = action_state.get_selected_entry()
		if selection then
			M.apply(selection.value, false)
		end
	end

	picker:find()
end

function M.setup()
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("user_theme", { clear = true }),
		callback = function(ev)
			local entry = by_colorscheme(ev.match)
			local palette = require("theme.palette")

			palette.refresh(entry ~= nil and entry.palette == "authored")
			require("theme.highlights").set_highlights(palette.current())
			if package.loaded["lualine"] then
				require("lualine").setup(require("theme.lualine").opts())
			end
		end,
	})

	vim.keymap.set("n", "<leader>uc", M.pick, { desc = "Themes" })

	local saved = vim.uv.fs_stat(STATE) and by_key(vim.fn.readfile(STATE)[1])
	M.apply(saved or M.registry[1], false)
end

return M
