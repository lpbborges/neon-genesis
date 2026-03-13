# AGENTS.md

> Guidelines for AI agents working in the neon-genesis.nvim codebase.

## Project Overview

**neon-genesis.nvim** is a Neovim colorscheme plugin written in pure Lua. It provides a high-contrast, cyberpunk-inspired theme with transparent background support.

- **Type**: Neovim colorscheme plugin
- **Language**: Lua
- **Minimum Neovim version**: 0.9+

## Project Structure

```
neon-genesis/
├── colors/
│   └── neon-genesis.lua    # Entry point - loads the theme
├── lua/
│   └── neon-genesis/
│       └── init.lua        # Main module - palette and highlight definitions
├── README.md
├── LICENSE
└── .gitignore
```

### Key Files

| File | Purpose |
|------|---------|
| `colors/neon-genesis.lua` | Neovim autoload entry point. Clears cache and calls `require('neon-genesis').load()` |
| `lua/neon-genesis/init.lua` | Core implementation: color palette, highlight groups, and `load()` function |

## Commands

### Testing the colorscheme

No automated tests. To manually test:

```bash
# Open Neovim and load the colorscheme
nvim -c "colorscheme neon-genesis"
```

### Development workflow

1. Edit `lua/neon-genesis/init.lua`
2. In Neovim, reload with `:colorscheme neon-genesis` (the colors file clears the cache)

## Code Patterns

### Color Palette

Colors are defined in a local table at the top of `init.lua`:

```lua
local colors = {
    cyan = "#00dede",
    green = "#28fa86",
    -- ...
    none = "none",      -- Used for transparent backgrounds
    surface = "#1c1c1c", -- Subtle UI surfaces (CursorLine, Folded)
    float_bg = "#11111b", -- Floating window backgrounds
    selection = "#2d2d3b", -- Visual selection, menu selection
    border = "#3e4452",   -- Borders, separators, faint UI elements
}
```

### Highlight Helper

All highlights use a local helper function wrapping `vim.api.nvim_set_hl`:

```lua
local function h(group, opts)
    nvim_set_hl(0, group, opts)
end
```

**Usage**: `h("GroupName", { fg = colors.cyan, bg = colors.none, bold = true })`

### Highlight Group Organization

Highlights in `init.lua` are organized in sections (maintain this order):
1. Terminal Ansi Colors
2. UI Highlights (Normal, Float, SignColumn, CursorLine, etc.)
3. Selection & Search (Visual, Search, MatchParen)
4. Messages & Modes (ErrorMsg, ModeMsg, etc.)
5. Editor Chrome (Folded, NonText, etc.)
6. Tabs (TabLine*)
7. Cursor & Spelling (TermCursor, Spell*)
8. Popup Menu (Pmenu*)
9. Syntax (Statement, Keyword, Function, etc.)
10. Treesitter (@variable, @function, @keyword, etc.)
11. Diagnostics (Diagnostic*)
12. LSP (LspReference*, LspSignature*, LspInlayHint)
13. Git (Diff*, GitSigns*)
14. UI Elements (StatusLine, WinSeparator)
15. Plugins (LazyGit, Telescope, nvim-cmp, nvim-tree, neo-tree, indent-blankline, which-key, Lazy.nvim)

### Transparency

The theme is transparent by default. Use `bg = colors.none` for transparent backgrounds:

```lua
h("Normal", { fg = colors.white, bg = colors.none })
```

## Naming Conventions

- **Color names**: Lowercase, descriptive (`cyan`, `green`, `purple`, `dark`)
- **Highlight groups**: Follow Neovim/Vim conventions (PascalCase)
- **Module**: Returns table `M` with `load()` function

## Adding New Highlights

1. Add to the appropriate section in `lua/neon-genesis/init.lua`
2. Use existing palette colors (add new colors to `colors` table if needed)
3. Use `colors.none` for transparent backgrounds
4. Test with `:colorscheme neon-genesis`

## Plugin Support

When adding support for new plugins:
1. Add a comment section header (e.g., `-- Telescope`)
2. Group related highlights together
3. Follow the plugin's highlight group naming conventions

Currently supported plugins:
- GitSigns
- LazyGit
- Telescope
- nvim-cmp
- nvim-tree
- neo-tree
- indent-blankline
- which-key
- Lazy.nvim

## Gotchas

- **Cache clearing**: `colors/neon-genesis.lua` uses `package.loaded['neon-genesis'] = nil` to clear the module cache on reload
- **termguicolors**: The theme sets `vim.o.termguicolors = true` automatically
- **colors_name**: Must set `vim.g.colors_name = "neon-genesis"` for Neovim to recognize the theme
