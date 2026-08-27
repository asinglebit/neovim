local base = require("theme.colors")

local M = {}

-- lightness distance of each authored grey from grey_900, preserved across every theme
local RAMP = {
	grey_900 = 0.000,
	grey_875 = 0.024,
	grey_850 = 0.039,
	grey_800 = 0.067,
	grey_700 = 0.145,
	grey_600 = 0.204,
	grey_500 = 0.290,
	grey_400 = 0.404,
	grey_300 = 0.529,
	grey_200 = 0.671,
	grey_100 = 0.745,
}

local RAMP_MAX = 0.745
local TINT_CEILING = 0.08 -- chroma the far end of the ramp settles at, or a cream background goes mustard

-- accent roles, resolved against the first group the active colorscheme actually sets
local ROLES = {
	vscGreen = { "DiagnosticOk", "GitSignsAdd", "Added" },
	vscGray = { "Comment" },
	vscOrange = { "String" },
	vscYellow = { "Function" },
	vscPink = { "Keyword", "Statement" },
	vscBlue = { "Type" },
	vscBlueGreen = { "@type", "Structure", "Constant" },
	vscLightBlue = { "Identifier", "@variable" },
	vscLightGreen = { "Number", "Constant" },
	vscRed = { "DiagnosticError", "ErrorMsg" },
	vscYellowOrange = { "Special" },
	vscViolet = { "DiagnosticHint" },
	vscAccentBlue = { "DiagnosticInfo" },
	vscDarkYellow = { "DiagnosticWarn" },
	vscGitAdded = { "DiagnosticOk", "GitSignsAdd", "Added" },
	vscGitModified = { "GitSignsChange", "DiagnosticWarn", "Changed" },
	vscGitDeleted = { "GitSignsDelete", "DiagnosticError", "Removed" },
}

-- neovim's stock diff colours: a theme that leaves these alone has not picked a colour at all
local STOCK = {
	["#B3F6C0"] = true,
	["#005523"] = true,
	["#8CF8F7"] = true,
	["#007373"] = true,
	["#FFC0B9"] = true,
	["#590008"] = true,
}

local function clamp(n)
	return math.min(1, math.max(0, n))
end

local function channels(hex)
	local n = tonumber(hex:sub(2), 16)
	return math.floor(n / 65536) % 256 / 255, math.floor(n / 256) % 256 / 255, n % 256 / 255
end

local function byte(n)
	return math.floor(clamp(n) * 255 + 0.5)
end

local function to_hex(r, g, b)
	return string.format("#%02X%02X%02X", byte(r), byte(g), byte(b))
end

local function to_hsl(r, g, b)
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local l, d = (max + min) / 2, max - min
	if d == 0 then
		return 0, 0, l
	end
	local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
	local h
	if max == r then
		h = (g - b) / d + (g < b and 6 or 0)
	elseif max == g then
		h = (b - r) / d + 2
	else
		h = (r - g) / d + 4
	end
	return h / 6, s, l
end

local function channel(p, q, t)
	t = t % 1
	if t < 1 / 6 then
		return p + (q - p) * 6 * t
	elseif t < 1 / 2 then
		return q
	elseif t < 2 / 3 then
		return p + (q - p) * (2 / 3 - t) * 6
	end
	return p
end

local function from_hsl(h, s, l)
	if s == 0 then
		return to_hex(l, l, l)
	end
	local q = l < 0.5 and l * (1 + s) or l + s - l * s
	local p = 2 * l - q
	return to_hex(channel(p, q, h + 1 / 3), channel(p, q, h), channel(p, q, h - 1 / 3))
end

local function blend(from, to, amount)
	local r1, g1, b1 = channels(from)
	local r2, g2, b2 = channels(to)
	return to_hex(r1 + (r2 - r1) * amount, g1 + (g2 - g1) * amount, b1 + (b2 - b1) * amount)
end

local function group_fg(names)
	for _, name in ipairs(names) do
		local set = vim.api.nvim_get_hl(0, { name = name, link = false })
		local fg = set.fg and string.format("#%06X", set.fg)
		if fg and not STOCK[fg] then
			return fg
		end
	end
end

local function derive()
	local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
	local c = vim.tbl_extend("force", {}, base)

	c.vscBack = normal.bg and string.format("#%06X", normal.bg) or base.vscBack
	c.white = normal.fg and string.format("#%06X", normal.fg) or base.white

	local r, g, b = channels(c.vscBack)
	local h, _, l = to_hsl(r, g, b)
	local sign = vim.o.background == "light" and -1 or 1
	-- chroma is held absolute: HSL saturation is meaningless as lightness nears either end
	local chroma = math.max(r, g, b) - math.min(r, g, b)
	local settled = math.min(chroma, TINT_CEILING)
	for name, delta in pairs(RAMP) do
		local level = clamp(l + sign * delta)
		local spread = 1 - math.abs(2 * level - 1)
		local tint = chroma + (settled - chroma) * delta / RAMP_MAX
		c[name] = from_hsl(h, spread > 0 and math.min(1, tint / spread) or 0, level)
	end
	c.grey_900 = c.vscBack -- the editor background is the theme's own, untouched

	for name, groups in pairs(ROLES) do
		c[name] = group_fg(groups) or base[name]
	end

	c.vscLightRed = blend(c.vscRed, c.grey_900, 0.25)
	c.vscDarkBlue = blend(c.grey_900, c.vscBlue, 0.25)
	c.vscMediumBlue = c.vscAccentBlue
	c.vscDisabledBlue = blend(c.vscBlue, c.grey_500, 0.5)
	c.vscGitRenamed = c.vscGitAdded
	c.vscGitUntracked = c.vscGitAdded
	c.vscGitStageModified = c.vscGitModified
	c.vscGitStageDeleted = c.vscGitDeleted
	c.vscGitConflicting = blend(c.vscGitAdded, c.grey_900, 0.25)
	c.vscDiffRedDark = blend(c.grey_900, c.vscGitDeleted, 0.15)
	c.vscDiffRedLight = blend(c.grey_900, c.vscGitDeleted, 0.25)
	c.vscDiffRedLightLight = c.vscRed
	c.vscDiffGreenDark = blend(c.grey_900, c.vscGitAdded, 0.15)
	c.vscDiffGreenLight = blend(c.grey_900, c.vscGitAdded, 0.25)

	-- the aliases theme/colors.lua defines over the ramp, re-pointed at the derived steps
	c.selection = c.grey_700
	c.vscTabCurrent = c.grey_900
	c.vscTabOther = c.grey_875
	c.vscTabOutside = c.grey_875
	c.vscLeftDark = c.grey_875
	c.vscLeftMid = c.grey_800
	c.vscLeftLight = c.grey_500
	c.vscPopupFront = c.grey_200
	c.vscPopupBack = c.grey_875
	c.vscSplitLight = c.grey_400
	c.vscSplitDark = c.grey_700
	c.vscSplitThumb = c.grey_700
	c.vscCursorDarkDark = c.grey_850
	c.vscCursorDark = c.grey_600
	c.vscCursorLight = c.grey_300
	c.vscLineNumber = c.grey_500
	c.vscSearchCurrent = c.grey_600
	c.vscSearch = c.grey_800
	c.vscGitIgnored = c.grey_400
	c.vscGitSubmodule = c.grey_400
	c.vscContext = c.grey_700
	c.vscContextCurrent = c.grey_500
	c.vscFoldBackground = c.grey_875
	c.vscSuggestion = c.grey_500
	c.vscDimHighlight = c.grey_700

	return c
end

local cache, authored

---Discard the derived palette; `use_authored` returns theme/colors.lua verbatim instead.
function M.refresh(use_authored)
	cache, authored = nil, use_authored
end

function M.current()
	if not cache then
		cache = authored and base or derive()
	end
	return cache
end

return M
