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
	vim.o.termguicolors = true

	-- Terminal Ansi Colors
	vim.g.terminal_color_1 = colors.red
	vim.g.terminal_color_9 = colors.red

	-- UI Highlights
	h("Normal", { fg = colors.white, bg = colors.none }) -- Transparent bg
	h("NormalNC", { bg = colors.none })
	h("NormalFloat", { fg = colors.white, bg = colors.none })
	h("FloatBorder", { fg = colors.cyan, bg = colors.none })
	h("SignColumn", { bg = colors.none })
	h("EndOfBuffer", { bg = colors.none, fg = colors.grey })
	h("LineNr", { fg = colors.grey, bg = colors.none })
	h("CursorLine", { bg = "#1c1c1c" })
	h("CursorLineNr", { fg = colors.cyan, bold = true })

	-- Popup Menu
	h("Pmenu", { bg = "#11111b", fg = colors.white })
	h("PmenuSel", { bg = "#2d2d3b", fg = colors.cyan, bold = true })
	h("PmenuBorder", { fg = colors.grey, bg = "#11111b" })

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

	-- Diagnostics
	h("DiagnosticError", { fg = colors.red })
	h("DiagnosticWarn", { fg = colors.yellow })
	h("DiagnosticInfo", { fg = colors.cyan })
	h("DiagnosticHint", { fg = colors.green })

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
	h("WinSeparator", { fg = "#3e4452", bg = colors.none })

	-- Plugins
	h("LazyGitBorder", { fg = colors.cyan, bg = colors.none })
	h("LazyGitFloat", { bg = colors.none })
end

return M
