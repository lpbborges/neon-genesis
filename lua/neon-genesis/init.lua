local M = {}

local nvim_set_hl = vim.api.nvim_set_hl

-- Palette Definition
local colors = {
	cyan = "#00dede",
	green = "#28fa86",
	white = "#e4e4e4",
	grey = "#5c6370",
	dark = "#080a10",
	blue = "#61afef",
	red = "#ff5555",
	yellow = "#f1fa8c",
	purple = "#bd93f9",
	none = "none",
	surface = "#1c1c1c",
	float_bg = "#11111b",
	selection = "#2d2d3b",
	border = "#3e4452",
}

local function h(group, opts)
	-- 0 means current buffer/global
	nvim_set_hl(0, group, opts)
end

function M.load()
	if vim.g.colors_name then
		vim.cmd("hi clear")
	end

	-- Required: Tell Neovim the theme name
	vim.g.colors_name = "neon-genesis"

	-- Terminal Ansi Colors
	vim.g.terminal_color_0 = colors.dark
	vim.g.terminal_color_1 = colors.red
	vim.g.terminal_color_2 = colors.green
	vim.g.terminal_color_3 = colors.yellow
	vim.g.terminal_color_4 = colors.blue
	vim.g.terminal_color_5 = colors.purple
	vim.g.terminal_color_6 = colors.cyan
	vim.g.terminal_color_7 = colors.white
	vim.g.terminal_color_8 = colors.grey
	vim.g.terminal_color_9 = colors.red
	vim.g.terminal_color_10 = colors.green
	vim.g.terminal_color_11 = colors.yellow
	vim.g.terminal_color_12 = colors.blue
	vim.g.terminal_color_13 = colors.purple
	vim.g.terminal_color_14 = colors.cyan
	vim.g.terminal_color_15 = colors.white

	-- UI Highlights
	h("Normal", { fg = colors.white, bg = colors.none }) -- Transparent bg
	h("NormalNC", { fg = colors.white, bg = colors.none })
	h("NormalFloat", { fg = colors.white, bg = colors.none })
	h("FloatBorder", { fg = colors.cyan, bg = colors.none })
	h("FloatTitle", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("SignColumn", { bg = colors.none })
	h("EndOfBuffer", { bg = colors.none, fg = colors.grey })
	h("LineNr", { fg = colors.grey, bg = colors.none })
	h("CursorLine", { bg = colors.surface })
	h("CursorLineNr", { fg = colors.cyan, bold = true })
	h("CursorColumn", { bg = colors.surface })
	h("ColorColumn", { bg = colors.surface })
	h("Conceal", { fg = colors.grey })

	-- Selection & Search
	h("Visual", { bg = colors.selection })
	h("VisualNOS", { bg = colors.selection })
	h("Search", { fg = colors.dark, bg = colors.yellow })
	h("IncSearch", { fg = colors.dark, bg = colors.cyan })
	h("CurSearch", { fg = colors.dark, bg = colors.green })
	h("Substitute", { fg = colors.dark, bg = colors.red })
	h("MatchParen", { fg = colors.cyan, bold = true, underline = true })

	-- Messages & Modes
	h("ErrorMsg", { fg = colors.red, bold = true })
	h("WarningMsg", { fg = colors.yellow, bold = true })
	h("ModeMsg", { fg = colors.cyan, bold = true })
	h("MoreMsg", { fg = colors.green })
	h("Question", { fg = colors.cyan })
	h("MsgArea", { fg = colors.white })

	-- Editor Chrome
	h("Folded", { fg = colors.grey, bg = colors.surface })
	h("FoldColumn", { fg = colors.grey, bg = colors.none })
	h("NonText", { fg = colors.border })
	h("Whitespace", { fg = colors.border })
	h("SpecialKey", { fg = colors.border })

	-- Tabs
	h("TabLine", { fg = colors.grey, bg = colors.surface })
	h("TabLineFill", { bg = colors.none })
	h("TabLineSel", { fg = colors.cyan, bg = colors.none, bold = true })
	h("WildMenu", { fg = colors.dark, bg = colors.cyan })

	-- Cursor & Spelling
	h("Cursor", { fg = colors.dark, bg = colors.cyan })
	h("lCursor", { fg = colors.dark, bg = colors.cyan })
	h("TermCursor", { reverse = true })
	h("SpellBad", { sp = colors.red, undercurl = true })
	h("SpellCap", { sp = colors.yellow, undercurl = true })
	h("SpellRare", { sp = colors.purple, undercurl = true })
	h("SpellLocal", { sp = colors.cyan, undercurl = true })

	-- Popup Menu
	h("Pmenu", { bg = colors.float_bg, fg = colors.white })
	h("PmenuSel", { bg = colors.selection, fg = colors.cyan, bold = true })
	h("PmenuBorder", { fg = colors.grey, bg = colors.float_bg })

	-- Syntax
	h("Statement", { fg = colors.cyan, bold = true })
	h("Keyword", { fg = colors.purple, bold = true }) -- EVA Purple
	h("Function", { fg = colors.cyan })
	h("Directory", { fg = colors.cyan, bold = true })
	h("Title", { fg = colors.cyan, bold = true })
	h("Operator", { fg = colors.cyan, bold = true })
	h("String", { fg = colors.green }) -- EVA Green
	h("Type", { fg = colors.green })
	h("Boolean", { fg = colors.green, bold = true })
	h("Comment", { fg = colors.grey, italic = true })
	h("Constant", { fg = colors.blue })
	h("Special", { fg = colors.purple })
	h("Identifier", { fg = colors.blue })
	h("PreProc", { fg = colors.cyan })

	-- Treesitter
	h("@variable", { fg = colors.white })
	h("@variable.builtin", { fg = colors.purple, italic = true })
	h("@variable.parameter", { fg = colors.blue, italic = true })
	h("@variable.member", { fg = colors.blue })

	h("@function", { fg = colors.cyan })
	h("@function.builtin", { fg = colors.cyan, italic = true })
	h("@function.call", { fg = colors.cyan })
	h("@function.method", { fg = colors.cyan })
	h("@function.method.call", { fg = colors.cyan })

	h("@keyword", { fg = colors.purple, bold = true })
	h("@keyword.return", { fg = colors.purple, bold = true })
	h("@keyword.function", { fg = colors.purple, bold = true })
	h("@keyword.operator", { fg = colors.cyan, bold = true })
	h("@keyword.import", { fg = colors.cyan })
	h("@keyword.conditional", { fg = colors.purple, bold = true })
	h("@keyword.repeat", { fg = colors.purple, bold = true })
	h("@keyword.exception", { fg = colors.red })

	h("@string", { fg = colors.green })
	h("@string.escape", { fg = colors.cyan })
	h("@character", { fg = colors.green })
	h("@character.special", { fg = colors.green, bold = true })
	h("@string.special", { fg = colors.green, bold = true })
	h("@string.regex", { fg = colors.yellow })
	h("@number", { fg = colors.blue })
	h("@boolean", { fg = colors.green, bold = true })
	h("@type", { fg = colors.green })
	h("@type.builtin", { fg = colors.green, italic = true })

	h("@punctuation.bracket", { fg = colors.white })
	h("@punctuation.delimiter", { fg = colors.white })
	h("@punctuation.special", { fg = colors.cyan })
	h("@constructor", { fg = colors.green })
	h("@property", { fg = colors.blue })
	h("@attribute", { fg = colors.purple })
	h("@namespace", { fg = colors.cyan, italic = true })
	h("@module", { fg = colors.cyan, italic = true })
	h("@operator", { fg = colors.cyan, bold = true })

	h("@comment", { fg = colors.grey, italic = true })
	h("@comment.todo", { fg = colors.yellow, bold = true })
	h("@comment.note", { fg = colors.cyan, bold = true })
	h("@comment.warning", { fg = colors.yellow, bold = true })
	h("@comment.error", { fg = colors.red, bold = true })

	h("@tag", { fg = colors.cyan })
	h("@tag.attribute", { fg = colors.purple })
	h("@tag.delimiter", { fg = colors.grey })

	-- Diagnostics
	h("DiagnosticError", { fg = colors.red })
	h("DiagnosticWarn", { fg = colors.yellow })
	h("DiagnosticInfo", { fg = colors.cyan })
	h("DiagnosticHint", { fg = colors.green })
	h("DiagnosticSignError", { fg = colors.red })
	h("DiagnosticSignWarn", { fg = colors.yellow })
	h("DiagnosticSignInfo", { fg = colors.cyan })
	h("DiagnosticSignHint", { fg = colors.green })
	h("DiagnosticUnderlineError", { sp = colors.red, undercurl = true })
	h("DiagnosticUnderlineWarn", { sp = colors.yellow, undercurl = true })
	h("DiagnosticUnderlineInfo", { sp = colors.cyan, undercurl = true })
	h("DiagnosticUnderlineHint", { sp = colors.green, undercurl = true })
	h("DiagnosticVirtualTextError", { fg = colors.red, italic = true })
	h("DiagnosticVirtualTextWarn", { fg = colors.yellow, italic = true })
	h("DiagnosticVirtualTextInfo", { fg = colors.cyan, italic = true })
	h("DiagnosticVirtualTextHint", { fg = colors.green, italic = true })

	-- LSP
	h("LspReferenceText", { bg = colors.selection })
	h("LspReferenceRead", { bg = colors.selection })
	h("LspReferenceWrite", { bg = colors.selection, bold = true })
	h("LspSignatureActiveParameter", { fg = colors.cyan, bold = true, underline = true })
	h("LspInlayHint", { fg = colors.grey, italic = true })

	-- Git
	h("DiffAdd", { fg = colors.green, bg = colors.none })
	h("GitSignsAdd", { fg = colors.green, bg = colors.none })
	h("DiffDelete", { fg = colors.red, bg = colors.none })
	h("GitSignsDelete", { fg = colors.red, bg = colors.none })
	h("DiffChange", { fg = colors.yellow, bg = colors.none })
	h("GitSignsChange", { fg = colors.yellow, bg = colors.none })
	h("DiffText", { fg = colors.blue, bg = colors.none, bold = true })

	-- UI Elements
	h("StatusLine", { bg = colors.none, fg = colors.white })
	h("StatusLineNC", { bg = colors.none, fg = colors.grey })
	h("WinSeparator", { fg = colors.border, bg = colors.none })

	-- Plugins: LazyGit
	h("LazyGitBorder", { fg = colors.cyan, bg = colors.none })
	h("LazyGitFloat", { bg = colors.none })

	-- Plugins: Telescope
	h("TelescopeNormal", { fg = colors.white, bg = colors.none })
	h("TelescopeBorder", { fg = colors.cyan, bg = colors.none })
	h("TelescopePromptNormal", { fg = colors.white, bg = colors.none })
	h("TelescopePromptBorder", { fg = colors.cyan, bg = colors.none })
	h("TelescopePromptTitle", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("TelescopePreviewTitle", { fg = colors.dark, bg = colors.green, bold = true })
	h("TelescopeResultsTitle", { fg = colors.dark, bg = colors.purple, bold = true })
	h("TelescopeSelection", { bg = colors.selection, fg = colors.cyan, bold = true })
	h("TelescopeSelectionCaret", { fg = colors.cyan })
	h("TelescopeMatching", { fg = colors.green, bold = true })

	-- Plugins: nvim-cmp
	h("CmpItemAbbr", { fg = colors.white })
	h("CmpItemAbbrMatch", { fg = colors.cyan, bold = true })
	h("CmpItemAbbrMatchFuzzy", { fg = colors.cyan })
	h("CmpItemKind", { fg = colors.purple })
	h("CmpItemMenu", { fg = colors.grey })
	h("CmpItemKindFunction", { fg = colors.cyan })
	h("CmpItemKindMethod", { fg = colors.cyan })
	h("CmpItemKindVariable", { fg = colors.blue })
	h("CmpItemKindKeyword", { fg = colors.purple })
	h("CmpItemKindText", { fg = colors.white })
	h("CmpItemKindSnippet", { fg = colors.yellow })

	-- Plugins: nvim-tree
	h("NvimTreeNormal", { fg = colors.white, bg = colors.none })
	h("NvimTreeFolderIcon", { fg = colors.cyan })
	h("NvimTreeFolderName", { fg = colors.cyan })
	h("NvimTreeOpenedFolderName", { fg = colors.cyan, bold = true })
	h("NvimTreeGitDirty", { fg = colors.yellow })
	h("NvimTreeGitNew", { fg = colors.green })
	h("NvimTreeGitDeleted", { fg = colors.red })

	-- Plugins: neo-tree
	h("NeoTreeNormal", { fg = colors.white, bg = colors.none })
	h("NeoTreeNormalNC", { fg = colors.white, bg = colors.none })
	h("NeoTreeDirectoryIcon", { fg = colors.cyan })
	h("NeoTreeDirectoryName", { fg = colors.cyan })
	h("NeoTreeGitModified", { fg = colors.yellow })
	h("NeoTreeGitAdded", { fg = colors.green })
	h("NeoTreeGitDeleted", { fg = colors.red })

	-- Plugins: indent-blankline
	h("IblIndent", { fg = colors.surface })
	h("IblScope", { fg = colors.border })

	-- Plugins: which-key
	h("WhichKey", { fg = colors.cyan })
	h("WhichKeyGroup", { fg = colors.purple })
	h("WhichKeyDesc", { fg = colors.white })
	h("WhichKeySeparator", { fg = colors.grey })
	h("WhichKeyFloat", { bg = colors.none })
	h("WhichKeyBorder", { fg = colors.cyan, bg = colors.none })

	-- Plugins: Lazy.nvim
	h("LazyButton", { fg = colors.white, bg = colors.surface })
	h("LazyButtonActive", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("LazyH1", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("LazySpecial", { fg = colors.cyan })

	-- Plugins: blink.cmp
	h("BlinkCmpMenu", { fg = colors.white, bg = colors.float_bg })
	h("BlinkCmpMenuBorder", { fg = colors.cyan, bg = colors.none })
	h("BlinkCmpMenuSelection", { fg = colors.cyan, bg = colors.selection, bold = true })
	h("BlinkCmpScrollBarGutter", { bg = colors.float_bg })
	h("BlinkCmpScrollBarThumb", { bg = colors.border })
	h("BlinkCmpLabel", { fg = colors.white })
	h("BlinkCmpLabelDeprecated", { fg = colors.grey, strikethrough = true })
	h("BlinkCmpLabelMatch", { fg = colors.cyan, bold = true })
	h("BlinkCmpLabelDetail", { fg = colors.grey })
	h("BlinkCmpLabelDescription", { fg = colors.grey })
	h("BlinkCmpKind", { fg = colors.purple })
	h("BlinkCmpKindFunction", { fg = colors.cyan })
	h("BlinkCmpKindMethod", { fg = colors.cyan })
	h("BlinkCmpKindConstructor", { fg = colors.green })
	h("BlinkCmpKindVariable", { fg = colors.blue })
	h("BlinkCmpKindField", { fg = colors.blue })
	h("BlinkCmpKindProperty", { fg = colors.blue })
	h("BlinkCmpKindKeyword", { fg = colors.purple })
	h("BlinkCmpKindText", { fg = colors.white })
	h("BlinkCmpKindSnippet", { fg = colors.yellow })
	h("BlinkCmpKindModule", { fg = colors.cyan })
	h("BlinkCmpKindClass", { fg = colors.green })
	h("BlinkCmpKindInterface", { fg = colors.green })
	h("BlinkCmpKindEnum", { fg = colors.green })
	h("BlinkCmpKindEnumMember", { fg = colors.blue })
	h("BlinkCmpKindStruct", { fg = colors.green })
	h("BlinkCmpKindTypeParameter", { fg = colors.green })
	h("BlinkCmpDoc", { fg = colors.white, bg = colors.float_bg })
	h("BlinkCmpDocBorder", { fg = colors.cyan, bg = colors.none })
	h("BlinkCmpDocSeparator", { fg = colors.border })
	h("BlinkCmpDocCursorLine", { bg = colors.selection })
	h("BlinkCmpSignatureHelp", { fg = colors.white, bg = colors.float_bg })
	h("BlinkCmpSignatureHelpBorder", { fg = colors.cyan, bg = colors.none })
	h("BlinkCmpSignatureHelpActiveParameter", { fg = colors.cyan, bold = true, underline = true })
	h("BlinkCmpGhostText", { fg = colors.grey, italic = true })

	-- LSP Semantic Tokens
	h("@lsp.type.function", { fg = colors.cyan })
	h("@lsp.type.method", { fg = colors.cyan })
	h("@lsp.type.variable", { fg = colors.white })
	h("@lsp.type.parameter", { fg = colors.blue, italic = true })
	h("@lsp.type.property", { fg = colors.blue })
	h("@lsp.type.class", { fg = colors.green })
	h("@lsp.type.interface", { fg = colors.green })
	h("@lsp.type.type", { fg = colors.green })
	h("@lsp.type.typeParameter", { fg = colors.green })
	h("@lsp.type.enum", { fg = colors.green })
	h("@lsp.type.enumMember", { fg = colors.blue })
	h("@lsp.type.namespace", { fg = colors.cyan, italic = true })
	h("@lsp.type.module", { fg = colors.cyan, italic = true })
	h("@lsp.type.keyword", { fg = colors.purple, bold = true })
	h("@lsp.type.string", { fg = colors.green })
	h("@lsp.type.number", { fg = colors.blue })
	h("@lsp.type.operator", { fg = colors.cyan })
	h("@lsp.type.decorator", { fg = colors.purple })
	h("@lsp.type.macro", { fg = colors.cyan })
	h("@lsp.mod.deprecated", { strikethrough = true })
end

return M
