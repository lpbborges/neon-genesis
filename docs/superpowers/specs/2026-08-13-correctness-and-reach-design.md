# neon-genesis.nvim: Correctness, Reach & Docs Improvements

**Date**: 2026-08-13
**Status**: Approved

## Goal

Improve neon-genesis.nvim in three areas: fix highlight-group correctness bugs, expand plugin/config reach, and add missing documentation. Scope explicitly excludes a light background variant and README screenshots (deferred by user request).

## A. Correctness fixes

- `GitSignsChange` links to `DiffChange` and `GitSignsDelete` links to `DiffDelete`, but neither `DiffChange` nor `DiffDelete` is defined in `init.lua` — they currently fall back to Neovim's built-in defaults instead of the theme's palette. Define both explicitly:
  - `DiffChange`: yellow fg/bg-tinted, consistent with existing `DiffAdd` (green) / `DiffText` (blue) conventions.
  - `DiffDelete`: red fg, `bg = colors.none` (matches `DiffAdd`/`DiffText` transparency pattern).
- Add `PmenuSbar` and `PmenuThumb` (popup menu scrollbar) — currently unset, so native/completion popup scrollbars don't match the theme. Use `colors.surface` for the track and `colors.border` (or `colors.grey`) for the thumb.

## B. Config API: `setup()` + style toggles

- Add `M.setup(opts)` as the primary entrypoint, callable before `vim.cmd.colorscheme("neon-genesis")`.
  - `opts.colors`: merged into the palette table — same mechanism as the existing `vim.g.neon_genesis_colors` override, which remains supported for backward compatibility (both work; `setup()` merges after the `vim.g` override so it takes precedence if both are set).
  - `opts.styles`: a table of style flags consumed when building highlight opts:
    - `styles.comments = { italic = true }` (default: `true`, matches current hardcoded behavior)
    - `styles.keywords = { bold = true }` (default: `true`)
    - `styles.functions = { bold = false }` (default: `false`)
  - Defaults exactly match today's hardcoded values, so users who don't call `setup()` see no behavior change.
- README updated to document both the zero-config path and the `setup()` path with an example showing color + style overrides together.

## C. New plugin highlight groups

Each addition follows the existing convention: link to established semantic groups (Diagnostic*, Float*, border/selection colors) rather than inventing new one-off colors, keeping the palette coherent.

- **lualine.nvim**: new file `lua/lualine/themes/neon-genesis.lua`, a standard lualine theme table (normal/insert/visual/replace/command/inactive mode colors) built from the existing palette, consumed via `require('lualine').setup({options={theme='neon-genesis'}})`.
- **mini.statusline**: `MiniStatuslineModeNormal`, `MiniStatuslineModeInsert`, `MiniStatuslineModeVisual`, `MiniStatuslineModeReplace`, `MiniStatuslineModeCommand`, `MiniStatuslineModeOther`, `MiniStatuslineDevinfo`, `MiniStatuslineFilename`, `MiniStatuslineFileinfo`, `MiniStatuslineInactive`.
- **noice.nvim**: `NoiceCmdlinePopup`, `NoiceCmdlinePopupBorder`, `NoiceCmdlineIcon`, `NoiceMini`, `NoicePopupmenu*` — mostly linked to existing Float/Pmenu/border groups.
- **trouble.nvim**: `TroubleNormal`, `TroubleText`, `TroubleCount`, `TroubleIndent`, and severity groups linked to `DiagnosticError/Warn/Info/Hint`.
- **mason.nvim**: `MasonHeader`, `MasonHighlight`, `MasonHighlightBlock`, `MasonMuted`, and install-state groups linked to existing cyan/green/grey semantics.
- **snacks.nvim**: dashboard groups (`SnacksDashboard*` — header/icon in cyan, footer in grey) and notifier groups (`SnacksNotifier*` — levels linked to Diagnostic colors).
- **flash.nvim**: `FlashLabel` (high-contrast cyan/bold), `FlashMatch`, `FlashCurrent`, `FlashBackdrop` (dimmed via grey).

New highlight groups added to `init.lua` follow the existing 17-section organization (`AGENTS.md`); each gets its own `-- Plugins: <name>` comment header appended after the current last plugin section, preserving file order.

## D. Docs

- **`doc/neon-genesis.txt`**: standard Neovim help file with `*neon-genesis.txt*` tag header and `:helptags`-compatible tags. Sections: Introduction, Installation, Usage (`:colorscheme neon-genesis` and `setup()`), Configuration (palette overrides + style toggles), Supported Plugins list.
- **`CONTRIBUTING.md`**: palette table, `h()` helper convention, section-ordering convention (from `AGENTS.md`), and a step-by-step "adding a new plugin's highlights" walkthrough with a worked example.

## Explicitly out of scope

- Light background variant (`vim.o.background` toggle / light palette).
- README screenshots/GIF.
