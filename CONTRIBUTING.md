# Contributing to neon-genesis.nvim

## Project layout

- `colors/neon-genesis.lua` — Neovim entry point. Clears the module cache and calls `require('neon-genesis').load()`.
- `lua/neon-genesis/init.lua` — palette, `setup()`, and all highlight group definitions.
- `lua/lualine/themes/neon-genesis.lua` — lualine.nvim theme (separate file per lualine's own convention).

## The palette

All colors are defined once in the `colors` table at the top of `init.lua`:

```lua
local colors = {
    cyan = "#00dede",
    green = "#28fa86",
    -- ...
    none = "none", -- used for transparent backgrounds
}
```

Reuse existing palette colors wherever the semantics match (e.g. errors are
always `colors.red`, strings/types are always `colors.green`). Only add a
new color if no existing one fits.

## The `h()` helper

All highlights are set through a local helper wrapping `vim.api.nvim_set_hl`:

```lua
h("GroupName", { fg = colors.cyan, bg = colors.none, bold = true })
```

## Section ordering

`init.lua` is organized into ordered sections (Terminal Ansi Colors, UI
Highlights, Selection & Search, ..., Plugins, LSP Semantic Tokens). Keep
new highlights in the correct existing section, or add a new
`-- Plugins: <name>` section after the last plugin section.

## Adding a new plugin's highlights

1. Check the plugin's own documentation or source for the exact highlight
   group names it defines or reads (e.g. `:help pluginname-highlights`, or
   grep the plugin's source for `vim.api.nvim_set_hl` / `hl-` references).
2. Add a `-- Plugins: <name>` comment header at the end of the Plugins
   section in `init.lua`.
3. Prefer **linking** to an existing semantic group over inventing a new
   color, e.g.:

   ```lua
   h("TroubleTextError", { link = "DiagnosticError" })
   ```

   Only assign a direct `fg`/`bg` color when no existing group's semantics
   match.
4. Verify the group resolves correctly:

   ```bash
   nvim --headless --clean -u NONE -c "set rtp+=." \
     -c "lua require('neon-genesis').load()" \
     -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'YourGroupName'})))" \
     -c "qa"
   ```

5. Add the plugin to the "Supported Plugins" lists in `README.md`,
   `AGENTS.md`, and `doc/neon-genesis.txt`.

### Worked example: adding `FlashLabel` for flash.nvim

```lua
-- Plugins: flash.nvim
h("FlashLabel", { fg = colors.dark, bg = colors.cyan, bold = true })
```

`flash.nvim`'s jump labels need a high-contrast treatment, so this uses a
direct color pairing (dark text on cyan) rather than a link, since no
existing group has that semantic (`Search`/`IncSearch` are closest but
serve a different purpose).
