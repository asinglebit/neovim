local palettes = require("theme.guitar.palettes")
local hl_util = require("theme.hl")

local M = {}

-- guitar numbers its ramp 950..50 and this config 900..100; both run background to
-- foreground in eleven steps, so they line up by position rather than by name
local RAMP = {
	grey_900 = "grey_950",
	grey_875 = "grey_900",
	grey_850 = "grey_800",
	grey_800 = "grey_700",
	grey_700 = "grey_600",
	grey_600 = "grey_500",
	grey_500 = "grey_400",
	grey_400 = "grey_300",
	grey_300 = "grey_200",
	grey_200 = "grey_100",
	grey_100 = "grey_50",
}

local ACCENTS = {
	vscRed = "red",
	vscLightRed = "grapefruit",
	vscPink = "purple",
	vscViolet = "durple",
	vscBlue = "blue",
	vscMediumBlue = "indigo",
	vscAccentBlue = "indigo",
	vscLightBlue = "cyan",
	vscBlueGreen = "teal",
	vscGreen = "green",
	vscLightGreen = "grass",
	vscYellow = "yellow",
	vscDarkYellow = "amber",
	vscYellowOrange = "brown",
	vscOrange = "orange",
	vscGitAdded = "green",
	vscGitUntracked = "green",
	vscGitRenamed = "green",
	vscGitModified = "blue",
	vscGitStageModified = "blue",
	vscGitDeleted = "red",
	vscGitStageDeleted = "red",
	vscGitConflicting = "orange",
	vscDiffGreenDark = "light_green_900",
	vscDiffGreenLight = "light_green_900",
	vscDiffRedDark = "dark_red",
	vscDiffRedLight = "dark_red",
	vscDiffRedLightLight = "red",
}

-- the roles where guitar's own meaning is unambiguous, so the ramp position does not decide
local ROLES = {
	selection = "grey_800",
	vscCursorDarkDark = "grey_900",
	vscSplitLight = "border",
	vscSplitDark = "border",
	vscSplitThumb = "border",
	vscLineNumber = "border",
	vscTabOther = "grey_900",
	vscTabOutside = "grey_900",
	vscLeftDark = "grey_900",
	vscPopupBack = "grey_900",
	vscFoldBackground = "grey_900",
	vscPopupFront = "highlighted",
	vscSearch = "grey_800",
	vscSearchCurrent = "grey_700",
}

local function channels(hex)
	local n = tonumber(hex:sub(2), 16)
	return math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256
end

local function relative_luminance(hex)
	local out = 0
	for i, weight in ipairs({ 0.2126, 0.7152, 0.0722 }) do
		local v = select(i, channels(hex)) / 255
		out = out + weight * (v <= 0.03928 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4)
	end
	return out
end

local function contrast(a, b)
	local x, y = relative_luminance(a), relative_luminance(b)
	if x < y then
		x, y = y, x
	end
	return (x + 0.05) / (y + 0.05)
end

---Resolve a guitar slot, turning terminal colour names into their xterm stand-in.
local function resolve(slots, name)
	local value = slots[name]
	local named = value:sub(1, 1) == "@" and hl_util.ANSI[value:sub(2)]
	return named and named[2] or value
end

local function build(label)
	local slots = palettes[label]
	local terminal = slots.grey_950:sub(1, 1) == "@"
	local c = { vscNone = "NONE", ___missing = "#FF0000" }

	for key, slot in pairs(RAMP) do
		c[key] = resolve(slots, slot)
	end
	for key, slot in pairs(ACCENTS) do
		c[key] = resolve(slots, slot)
	end
	for key, slot in pairs(ROLES) do
		c[key] = resolve(slots, slot)
	end

	c.vscBack = c.grey_900
	-- guitar's `text` is the resting row colour, which a few themes deliberately keep dim
	local text, highlighted = resolve(slots, "text"), resolve(slots, "highlighted")
	c.white = (not terminal and contrast(text, c.vscBack) < 3.0) and highlighted or text

	c.vscGray = c.grey_400
	c.vscDisabledBlue = c.grey_500
	c.vscDarkBlue = c.grey_850
	c.vscGitIgnored = c.grey_500
	c.vscGitSubmodule = c.grey_500
	c.vscLeftMid = c.grey_800
	c.vscLeftLight = c.grey_500
	c.vscTabCurrent = c.grey_900
	c.vscCursorDark = c.grey_600
	c.vscCursorLight = c.grey_300
	c.vscContext = c.grey_700
	c.vscContextCurrent = c.grey_500
	c.vscSuggestion = c.grey_500
	c.vscDimHighlight = c.grey_700

	return c, terminal
end

local function core(hl, c)
	hl(0, "Normal", { fg = c.white, bg = c.vscBack })
	hl(0, "NormalNC", { fg = c.white, bg = c.vscBack })
	hl(0, "NormalFloat", { fg = c.vscPopupFront, bg = c.vscPopupBack })
	hl(0, "FloatBorder", { fg = c.vscPopupBack, bg = c.vscPopupBack })
	hl(0, "FloatTitle", { fg = c.white, bg = c.vscPopupBack })
	hl(0, "ColorColumn", { bg = c.vscCursorDarkDark })
	hl(0, "Cursor", { fg = c.vscCursorDark, bg = c.vscCursorLight })
	hl(0, "lCursor", { link = "Cursor" })
	hl(0, "TermCursor", { link = "Cursor" })
	hl(0, "CursorLine", { bg = c.vscCursorDarkDark })
	hl(0, "CursorColumn", { bg = c.vscCursorDarkDark })
	hl(0, "CursorLineNr", { fg = c.vscPopupFront, bg = c.vscBack })
	hl(0, "LineNr", { fg = c.vscLineNumber, bg = c.vscBack })
	hl(0, "SignColumn", { bg = c.vscBack })
	hl(0, "EndOfBuffer", { fg = c.vscBack })
	hl(0, "VertSplit", { fg = c.vscSplitDark, bg = c.vscBack })
	hl(0, "WinSeparator", { link = "VertSplit" })
	hl(0, "Folded", { fg = c.grey_400, bg = c.vscFoldBackground })
	hl(0, "FoldColumn", { fg = c.vscLineNumber, bg = c.vscBack })
	hl(0, "MatchParen", { bg = c.vscDimHighlight, bold = true })
	hl(0, "NonText", { fg = c.vscLineNumber })
	hl(0, "Whitespace", { fg = c.vscLineNumber })
	hl(0, "SpecialKey", { fg = c.vscLineNumber })
	hl(0, "Visual", { bg = c.selection })
	hl(0, "VisualNOS", { bg = c.selection })
	hl(0, "Search", { bg = c.vscSearch })
	hl(0, "IncSearch", { fg = c.white, bg = c.vscSearchCurrent })
	hl(0, "CurSearch", { link = "IncSearch" })
	hl(0, "Substitute", { link = "IncSearch" })
	hl(0, "Pmenu", { fg = c.vscPopupFront, bg = c.vscPopupBack })
	hl(0, "PmenuSel", { fg = c.vscPopupFront, bg = c.selection })
	hl(0, "PmenuSbar", { bg = c.vscPopupBack })
	hl(0, "PmenuThumb", { bg = c.grey_700 })
	hl(0, "StatusLine", { fg = c.grey_400, bg = c.grey_800 })
	hl(0, "StatusLineNC", { fg = c.grey_500, bg = c.grey_900 })
	hl(0, "TabLine", { fg = c.grey_400, bg = c.vscTabOther })
	hl(0, "TabLineFill", { bg = c.vscTabOutside })
	hl(0, "TabLineSel", { fg = c.white, bg = c.vscTabCurrent })
	hl(0, "WinBar", { fg = c.grey_400, bg = c.vscBack })
	hl(0, "WinBarNC", { fg = c.grey_500, bg = c.vscBack })
	hl(0, "Title", { fg = c.vscPopupFront, bold = true })
	hl(0, "ErrorMsg", { fg = c.vscRed })
	hl(0, "WarningMsg", { fg = c.vscDarkYellow })
	hl(0, "ModeMsg", { fg = c.white })
	hl(0, "MoreMsg", { fg = c.white })
	hl(0, "Question", { fg = c.vscBlue })
	hl(0, "Directory", { fg = c.vscBlue })
	hl(0, "Conceal", { fg = c.grey_500 })
	hl(0, "QuickFixLine", { bg = c.selection })
	hl(0, "WildMenu", { bg = c.selection })
	hl(0, "SpellBad", { sp = c.vscRed, undercurl = true })
	hl(0, "SpellCap", { sp = c.vscDarkYellow, undercurl = true })
	hl(0, "SpellLocal", { sp = c.vscAccentBlue, undercurl = true })
	hl(0, "SpellRare", { sp = c.vscViolet, undercurl = true })

	hl(0, "Comment", { fg = c.vscGray })
	hl(0, "Constant", { fg = c.vscBlue })
	hl(0, "String", { fg = c.vscOrange })
	hl(0, "Character", { fg = c.vscOrange })
	hl(0, "Number", { fg = c.vscLightGreen })
	hl(0, "Float", { fg = c.vscLightGreen })
	hl(0, "Boolean", { fg = c.vscLightGreen })
	hl(0, "Identifier", { fg = c.vscLightBlue })
	hl(0, "Function", { fg = c.vscYellow })
	hl(0, "Statement", { fg = c.vscPink })
	hl(0, "Conditional", { fg = c.vscPink })
	hl(0, "Repeat", { fg = c.vscPink })
	hl(0, "Label", { fg = c.vscPink })
	hl(0, "Exception", { fg = c.vscPink })
	hl(0, "Keyword", { fg = c.vscPink })
	hl(0, "Operator", { fg = c.white })
	hl(0, "PreProc", { fg = c.vscPink })
	hl(0, "Include", { fg = c.vscPink })
	hl(0, "Define", { fg = c.vscPink })
	hl(0, "Macro", { fg = c.vscPink })
	hl(0, "PreCondit", { fg = c.vscPink })
	hl(0, "Type", { fg = c.vscBlueGreen })
	hl(0, "StorageClass", { fg = c.vscBlue })
	hl(0, "Structure", { fg = c.vscBlueGreen })
	hl(0, "Typedef", { fg = c.vscBlueGreen })
	hl(0, "Special", { fg = c.vscYellowOrange })
	hl(0, "SpecialChar", { fg = c.vscYellowOrange })
	hl(0, "Tag", { fg = c.vscBlue })
	hl(0, "Delimiter", { fg = c.white })
	hl(0, "SpecialComment", { fg = c.grey_300 })
	hl(0, "Debug", { fg = c.vscYellowOrange })
	hl(0, "Underlined", { fg = c.vscLightBlue, underline = true })
	hl(0, "Ignore", { fg = c.grey_500 })
	hl(0, "Error", { fg = c.vscRed })
	hl(0, "Todo", { fg = c.vscDarkYellow, bold = true })

	hl(0, "@comment", { link = "Comment" })
	hl(0, "@comment.error", { fg = c.vscRed })
	hl(0, "@comment.warning", { fg = c.vscDarkYellow })
	hl(0, "@comment.todo", { link = "Todo" })
	hl(0, "@comment.note", { fg = c.vscAccentBlue })
	hl(0, "@string", { link = "String" })
	hl(0, "@string.escape", { fg = c.vscYellowOrange })
	hl(0, "@string.special", { fg = c.vscYellowOrange })
	hl(0, "@string.regexp", { fg = c.vscLightRed })
	hl(0, "@character", { link = "Character" })
	hl(0, "@number", { link = "Number" })
	hl(0, "@boolean", { link = "Boolean" })
	hl(0, "@float", { link = "Float" })
	hl(0, "@function", { link = "Function" })
	hl(0, "@function.call", { link = "Function" })
	hl(0, "@function.builtin", { link = "Function" })
	hl(0, "@function.macro", { fg = c.vscPink })
	hl(0, "@function.method", { link = "Function" })
	hl(0, "@function.method.call", { link = "Function" })
	hl(0, "@constructor", { fg = c.vscBlueGreen })
	hl(0, "@parameter", { fg = c.vscLightBlue })
	hl(0, "@variable.parameter", { fg = c.vscLightBlue })
	hl(0, "@keyword", { link = "Keyword" })
	hl(0, "@keyword.function", { link = "Keyword" })
	hl(0, "@keyword.operator", { link = "Keyword" })
	hl(0, "@keyword.return", { link = "Keyword" })
	hl(0, "@keyword.import", { link = "Keyword" })
	hl(0, "@keyword.exception", { link = "Keyword" })
	hl(0, "@keyword.conditional", { link = "Keyword" })
	hl(0, "@keyword.repeat", { link = "Keyword" })
	hl(0, "@type", { link = "Type" })
	hl(0, "@type.builtin", { fg = c.vscBlue })
	hl(0, "@type.definition", { link = "Type" })
	hl(0, "@type.qualifier", { fg = c.vscBlue })
	hl(0, "@attribute", { fg = c.vscBlueGreen })
	hl(0, "@variable", { fg = c.vscLightBlue })
	hl(0, "@variable.builtin", { fg = c.vscBlue })
	hl(0, "@variable.member", { fg = c.vscLightBlue })
	hl(0, "@property", { fg = c.vscLightBlue })
	hl(0, "@field", { fg = c.vscLightBlue })
	hl(0, "@constant", { fg = c.vscBlue })
	hl(0, "@constant.builtin", { fg = c.vscBlue })
	hl(0, "@constant.macro", { fg = c.vscPink })
	hl(0, "@module", { fg = c.vscBlueGreen })
	hl(0, "@namespace", { fg = c.vscBlueGreen })
	hl(0, "@operator", { fg = c.white })
	hl(0, "@punctuation.delimiter", { fg = c.white })
	hl(0, "@punctuation.bracket", { fg = c.white })
	hl(0, "@punctuation.special", { fg = c.vscYellowOrange })
	hl(0, "@tag", { fg = c.vscBlue })
	hl(0, "@tag.builtin", { fg = c.vscBlue })
	hl(0, "@tag.attribute", { fg = c.vscLightBlue })
	hl(0, "@tag.delimiter", { fg = c.grey_300 })
	hl(0, "@label", { fg = c.vscPink })
	hl(0, "@markup.heading", { fg = c.vscBlue, bold = true })
	hl(0, "@markup.strong", { bold = true })
	hl(0, "@markup.italic", { italic = true })
	hl(0, "@markup.strikethrough", { strikethrough = true })
	hl(0, "@markup.underline", { underline = true })
	hl(0, "@markup.link", { fg = c.vscLightBlue, underline = true })
	hl(0, "@markup.link.label", { fg = c.vscLightBlue })
	hl(0, "@markup.link.url", { fg = c.vscLightBlue, underline = true })
	hl(0, "@markup.raw", { fg = c.vscOrange })
	hl(0, "@markup.list", { fg = c.vscBlue })
	hl(0, "@markup.quote", { fg = c.vscGreen })
	hl(0, "@markup.math", { fg = c.vscLightGreen })
	hl(0, "@diff.plus", { fg = c.vscGitAdded })
	hl(0, "@diff.minus", { fg = c.vscGitDeleted })
	hl(0, "@diff.delta", { fg = c.vscGitModified })

	hl(0, "@lsp.type.class", { link = "Type" })
	hl(0, "@lsp.type.enum", { link = "Type" })
	hl(0, "@lsp.type.interface", { link = "Type" })
	hl(0, "@lsp.type.struct", { link = "Type" })
	hl(0, "@lsp.type.namespace", { fg = c.vscBlueGreen })
	hl(0, "@lsp.type.parameter", { fg = c.vscLightBlue })
	hl(0, "@lsp.type.property", { fg = c.vscLightBlue })
	hl(0, "@lsp.type.variable", { fg = c.vscLightBlue })
	hl(0, "@lsp.type.enumMember", { fg = c.vscBlue })
	hl(0, "@lsp.type.macro", { fg = c.vscPink })
	hl(0, "@lsp.type.decorator", { fg = c.vscYellow })
	hl(0, "LspReferenceText", { bg = c.vscDimHighlight })
	hl(0, "LspReferenceRead", { bg = c.vscDimHighlight })
	hl(0, "LspReferenceWrite", { bg = c.vscDimHighlight })
	hl(0, "LspInlayHint", { fg = c.grey_500 })
	hl(0, "LspSignatureActiveParameter", { fg = c.vscYellowOrange })
	hl(0, "LspCodeLens", { fg = c.grey_500 })

	local severities = {
		Error = c.vscRed,
		Warn = c.vscDarkYellow,
		Info = c.vscAccentBlue,
		Hint = c.vscViolet,
		Ok = c.vscGreen,
	}
	for name, colour in pairs(severities) do
		hl(0, "Diagnostic" .. name, { fg = colour })
		hl(0, "DiagnosticSign" .. name, { fg = colour, bg = c.vscBack })
		hl(0, "DiagnosticVirtualText" .. name, { fg = colour })
		hl(0, "DiagnosticFloating" .. name, { fg = colour })
		hl(0, "DiagnosticUnderline" .. name, { sp = colour, undercurl = true })
	end

	hl(0, "DiffAdd", { bg = c.vscDiffGreenDark })
	hl(0, "DiffDelete", { fg = c.vscGitDeleted, bg = c.vscDiffRedDark })
	hl(0, "DiffChange", { bg = c.grey_875 })
	hl(0, "DiffText", { bg = c.grey_800 })
	hl(0, "diffAdded", { fg = c.vscGitAdded })
	hl(0, "diffRemoved", { fg = c.vscGitDeleted })
	hl(0, "diffChanged", { fg = c.vscGitModified })
	hl(0, "diffFile", { fg = c.vscBlue })
	hl(0, "diffLine", { fg = c.grey_400 })
	hl(0, "Added", { fg = c.vscGitAdded })
	hl(0, "Removed", { fg = c.vscGitDeleted })
	hl(0, "Changed", { fg = c.vscGitModified })
	hl(0, "GitSignsAdd", { fg = c.vscGitAdded })
	hl(0, "GitSignsChange", { fg = c.vscGitModified })
	hl(0, "GitSignsDelete", { fg = c.vscGitDeleted })
end

local active

---The palette the last guitar colourscheme built, handed to theme.palette verbatim.
function M.palette()
	return active
end

function M.load(label)
	local c, terminal = build(label)

	-- clear the name first: changing `background` re-sources whatever is still named here
	vim.g.colors_name = nil
	vim.o.background = palettes[label].light and "light" or "dark"
	vim.cmd("highlight clear")
	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end
	vim.o.termguicolors = not terminal
	vim.g.colors_name = "guitar-" .. label:gsub(" ", "-")

	active = c
	core(hl_util.setter(), c)

	local ansi_order = {
		c.grey_900, c.vscRed, c.vscGreen, c.vscYellow, c.vscBlue, c.vscPink, c.vscLightBlue, c.grey_300,
		c.grey_500, c.vscLightRed, c.vscLightGreen, c.vscDarkYellow, c.vscMediumBlue, c.vscViolet,
		c.vscBlueGreen, c.grey_100,
	}
	for i, colour in ipairs(ansi_order) do
		vim.g["terminal_color_" .. (i - 1)] = colour
	end
end

return M
