# neon-genesis.nvim: Correctness, Reach & Docs Improvements

**Date**: 2026-08-13
**Status**: Approved

## Goal

Improve neon-genesis.nvim in three areas: fix highlight-group correctness bugs, expand plugin/config reach, and add missing documentation. Scope explicitly excludes a light background variant and README screenshots (deferred by user request).

## A. Correctness fixes

- `GitSignsChange` links to `DiffChange` and `GitSignsDelete` links to `DiffDelete`, but neither `DiffChange` nor `DiffDelete` is defined in `init.lua` — they currently fall back to Neovim's built-in defaults instead of the theme's palette. Define both explicitly, matching the existing `DiffAdd`/`DiffText` pattern of `bg = colors.none` (init.lua:234, :238 — neither uses a tinted background, so `DiffChange`/`DiffDelete` should not either):
  - `DiffChange`: `{ fg = colors.yellow, bg = colors.none }`
  - `DiffDelete`: `{ fg = colors.red, bg = colors.none }`
- Add `PmenuSbar` and `PmenuThumb` (popup menu scrollbar) — currently unset, so native/completion popup scrollbars don't match the theme:
  - `PmenuSbar`: `{ bg = colors.surface }`
  - `PmenuThumb`: `{ bg = colors.border }`

## B. Config API: `setup()` + style toggles

**Persistence constraint**: `colors/neon-genesis.lua` runs `package.loaded['neon-genesis'] = nil` before every `require('neon-genesis').load()`, which discards any state held in module-local variables. `setup()` must therefore store its options in `vim.g` (which survives the module cache-clear), not in a module-local table — the same reason today's `vim.g.neon_genesis_colors` mechanism works across reloads.

- Add `M.setup(opts)` as the primary entrypoint, callable before `vim.cmd.colorscheme("neon-genesis")`:
  ```lua
  function M.setup(opts)
    vim.g.neon_genesis_config = opts or {}
  end
  ```
- At the top of `init.lua` (module-load time, which re-runs on every `require` since the cache is cleared each reload), read `vim.g.neon_genesis_config` and merge:
  - `opts.colors` merged into the palette table after `vim.g.neon_genesis_colors` is applied, so `setup({colors=...})` takes precedence if both mechanisms are used. `vim.g.neon_genesis_colors` remains supported standalone for backward compatibility.
  - `opts.styles` stored as a local `styles` table with defaults, described below.
- `styles` flags and the exact groups each one governs (only these groups change behavior; all other hardcoded bold/italic in the file — e.g. `@comment.todo`, `@keyword.exception`, `Boolean` — are semantic, not style-toggle-controlled, and stay hardcoded):
  - `styles.comments.italic` (default `true`) → governs `Comment`, `@comment`, `@markup.quote`, `LspInlayHint`
  - `styles.keywords.bold` (default `true`) → governs `Statement`, `Keyword`, `@keyword`
  - `styles.functions.bold` (default `false`) → governs `Function`, `@function`
  - Defaults exactly match today's hardcoded values, so users who don't call `setup()` see no behavior change.
- README updated to document both the zero-config path and the `setup()` path with an example showing color + style overrides together.

## C. New plugin highlight groups

Each addition follows the existing convention: link to established semantic groups (Diagnostic*, Float*, border/selection colors) rather than inventing new one-off colors, keeping the palette coherent.

- **lualine.nvim**: new file `lua/lualine/themes/neon-genesis.lua`, a standard lualine theme table consumed via `require('lualine').setup({options={theme='neon-genesis'}})`. Mode `a`/`b`/`c` sections per lualine convention (`a` = bold mode label, `bg`-filled; `b`/`c` = subdued, `bg = colors.surface`/`none`):
  - `normal.a = { fg = colors.dark, bg = colors.cyan, gui = "bold" }`, `normal.b = { fg = colors.cyan, bg = colors.surface }`, `normal.c = { fg = colors.white, bg = colors.none }`
  - `insert.a = { fg = colors.dark, bg = colors.green, gui = "bold" }` (b/c as normal)
  - `visual.a = { fg = colors.dark, bg = colors.purple, gui = "bold" }` (b/c as normal)
  - `replace.a = { fg = colors.dark, bg = colors.red, gui = "bold" }` (b/c as normal)
  - `command.a = { fg = colors.dark, bg = colors.yellow, gui = "bold" }` (b/c as normal)
  - `inactive.a/b/c = { fg = colors.grey, bg = colors.none }`
- **mini.statusline**: mode groups mirror the lualine mode colors above (`MiniStatuslineModeNormal` = cyan bg/dark fg bold, `MiniStatuslineModeInsert` = green, `MiniStatuslineModeVisual` = purple, `MiniStatuslineModeReplace` = red, `MiniStatuslineModeCommand` = yellow, `MiniStatuslineModeOther` = blue); `MiniStatuslineDevinfo = { fg = colors.white, bg = colors.surface }`; `MiniStatuslineFilename = { fg = colors.grey, bg = colors.none }`; `MiniStatuslineFileinfo = { fg = colors.white, bg = colors.surface }`; `MiniStatuslineInactive = { fg = colors.grey, bg = colors.none }`.
- **noice.nvim**: `NoiceCmdlinePopup = { link = "NormalFloat" }`, `NoiceCmdlinePopupBorder = { link = "FloatBorder" }`, `NoiceCmdlineIcon = { fg = colors.cyan }`, `NoiceMini = { link = "NormalFloat" }`, `NoicePopupmenu = { link = "Pmenu" }`, `NoicePopupmenuBorder = { link = "FloatBorder" }`, `NoicePopupmenuSelected = { link = "PmenuSel" }`.
- **trouble.nvim**: `TroubleNormal = { fg = colors.white, bg = colors.none }`, `TroubleText = { fg = colors.white }`, `TroubleCount = { fg = colors.cyan, bold = true }`, `TroubleIndent = { fg = colors.border }`, `TroubleFoldIcon = { fg = colors.grey }`; severity groups link to `DiagnosticError/Warn/Info/Hint` (`TroubleTextError`, `TroubleTextWarning`, `TroubleTextInformation`, `TroubleTextHint`).
- **mason.nvim**: `MasonHeader = { fg = colors.dark, bg = colors.cyan, bold = true }`, `MasonHighlight = { fg = colors.cyan }`, `MasonHighlightBlock = { fg = colors.dark, bg = colors.cyan }`, `MasonHighlightBlockBold = { fg = colors.dark, bg = colors.cyan, bold = true }`, `MasonMuted = { fg = colors.grey }`, `MasonMutedBlock = { fg = colors.white, bg = colors.surface }`; install-state: `MasonHighlightBlockGreen = { fg = colors.dark, bg = colors.green }` (installed), `MasonMutedBlockGreen = { fg = colors.green, bg = colors.surface }` (installed, subdued), `MasonHighlightBlockRed = { fg = colors.dark, bg = colors.red }` (error).
- **snacks.nvim**: `SnacksDashboardHeader = { fg = colors.cyan, bold = true }`, `SnacksDashboardIcon = { fg = colors.cyan }`, `SnacksDashboardDesc = { fg = colors.white }`, `SnacksDashboardKey = { fg = colors.purple }`, `SnacksDashboardFooter = { fg = colors.grey, italic = true }`; notifier levels link to Diagnostic colors: `SnacksNotifierError = { link = "DiagnosticError" }`, `SnacksNotifierWarn = { link = "DiagnosticWarn" }`, `SnacksNotifierInfo = { link = "DiagnosticInfo" }`, `SnacksNotifierDebug = { link = "DiagnosticHint" }`, `SnacksNotifierTrace = { fg = colors.grey }`.
- **flash.nvim**: `FlashLabel = { fg = colors.dark, bg = colors.cyan, bold = true }`, `FlashMatch = { fg = colors.white, bg = colors.selection }`, `FlashCurrent = { fg = colors.dark, bg = colors.green, bold = true }`, `FlashBackdrop = { fg = colors.grey }`.

New highlight groups added to `init.lua` follow the existing 17-section organization (`AGENTS.md`); each gets its own `-- Plugins: <name>` comment header appended after the current last plugin section, preserving file order. `README.md`'s "Supported Plugins" list and `AGENTS.md`'s "Currently supported plugins" list are both updated to include the seven new plugins.

## D. Docs

- **`doc/neon-genesis.txt`**: standard Neovim help file with `*neon-genesis.txt*` tag header and `:helptags`-compatible tags. Sections: Introduction, Installation, Usage (`:colorscheme neon-genesis` and `setup()`), Configuration (palette overrides + style toggles), Supported Plugins list.
- **`CONTRIBUTING.md`**: palette table, `h()` helper convention, section-ordering convention (from `AGENTS.md`), and a step-by-step "adding a new plugin's highlights" walkthrough with a worked example.

## Explicitly out of scope

- Light background variant (`vim.o.background` toggle / light palette).
- README screenshots/GIF.
