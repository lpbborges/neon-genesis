local colors = {
	dark = "#080a10",
	cyan = "#00dede",
	green = "#28fa86",
	purple = "#bd93f9",
	red = "#ff5555",
	yellow = "#f1fa8c",
	white = "#e4e4e4",
	grey = "#5c6370",
	surface = "#1c1c1c",
	none = "none",
}

local function mode(bg)
	return {
		a = { fg = colors.dark, bg = bg, gui = "bold" },
		b = { fg = bg, bg = colors.surface },
		c = { fg = colors.white, bg = colors.none },
	}
end

return {
	normal = mode(colors.cyan),
	insert = mode(colors.green),
	visual = mode(colors.purple),
	replace = mode(colors.red),
	command = mode(colors.yellow),
	inactive = {
		a = { fg = colors.grey, bg = colors.none },
		b = { fg = colors.grey, bg = colors.none },
		c = { fg = colors.grey, bg = colors.none },
	},
}
