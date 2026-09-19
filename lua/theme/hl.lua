local M = {}

-- ratatui's colour names against the terminal slot each one means, plus the xterm hex
-- that stands in for it whenever a gui colour is still required
M.ANSI = {
	black = { 0, "#000000" },
	red = { 1, "#800000" },
	green = { 2, "#008000" },
	yellow = { 3, "#808000" },
	blue = { 4, "#000080" },
	magenta = { 5, "#800080" },
	cyan = { 6, "#008080" },
	gray = { 7, "#c0c0c0" },
	dark_gray = { 8, "#808080" },
	light_red = { 9, "#ff0000" },
	light_green = { 10, "#00ff00" },
	light_yellow = { 11, "#ffff00" },
	light_blue = { 12, "#0000ff" },
	light_magenta = { 13, "#ff00ff" },
	light_cyan = { 14, "#00ffff" },
	white = { 15, "#ffffff" },
	reset = { "NONE", "NONE" },
}

local ATTRS = { "bold", "italic", "underline", "undercurl", "underdouble", "underdotted", "underdashed", "strikethrough", "reverse", "standout", "nocombine" }

local slots = {}
for _, entry in pairs(M.ANSI) do
	if entry[1] ~= "NONE" then
		table.insert(slots, entry)
	end
end

local function nearest(hex)
	if type(hex) ~= "string" or hex:sub(1, 1) ~= "#" then
		return "NONE"
	end
	local n = tonumber(hex:sub(2), 16)
	local r, g, b = math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256
	local best, distance = "NONE", math.huge
	for _, entry in ipairs(slots) do
		local m = tonumber(entry[2]:sub(2), 16)
		local dr = r - math.floor(m / 65536) % 256
		local dg = g - math.floor(m / 256) % 256
		local db = b - m % 256
		local d = dr * dr + dg * dg + db * db
		if d < distance then
			best, distance = entry[1], d
		end
	end
	return best
end

---Paint with the terminal's own sixteen colours; gui values are ignored without truecolour.
local function cterm(ns, name, opts)
	if opts.link then
		return vim.api.nvim_set_hl(ns, name, opts)
	end
	local out = { ctermfg = nearest(opts.fg), ctermbg = nearest(opts.bg), cterm = {} }
	for _, attr in ipairs(ATTRS) do
		out.cterm[attr] = opts[attr]
	end
	vim.api.nvim_set_hl(ns, name, out)
end

---The `nvim_set_hl` to use for the colourscheme that is loading right now.
function M.setter()
	return vim.o.termguicolors and vim.api.nvim_set_hl or cterm
end

return M
