# neon-genesis.nvim: Correctness, Reach & Docs Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix broken highlight-group links, add a `setup()` config API with style toggles, add highlight support for seven new plugins, and add missing documentation to neon-genesis.nvim.

**Architecture:** All highlight changes live in the single existing `lua/neon-genesis/init.lua` (following the file's established 17-section pattern), except the new lualine theme, which is a separate file per lualine's own convention (`lua/lualine/themes/neon-genesis.lua`). No test framework exists in this repo; verification is done via headless Neovim invocations that load the colorscheme and assert on the resulting highlight-group tables with `vim.api.nvim_get_hl`.

**Tech Stack:** Pure Lua, Neovim 0.9+ API (`vim.api.nvim_set_hl`, `vim.api.nvim_get_hl`).

**Spec:** `docs/superpowers/specs/2026-08-13-correctness-and-reach-design.md`

---

## Verification convention

Every task's test step runs the colorscheme headless from the repo root and inspects the resulting highlight table:

```bash
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').load()" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'GROUP_NAME'})))" -c "qa" 2>&1
```

Replace `GROUP_NAME` per task. Run from `/home/lp2am/code/auto/neon-genesis`.

---

### Task 1: Fix DiffChange/DiffDelete and add Pmenu scrollbar groups

**Files:**
- Modify: `lua/neon-genesis/init.lua:233-238` (Git section), `lua/neon-genesis/init.lua:117-120` (Popup Menu section)

- [ ] **Step 1: Add `DiffChange` and `DiffDelete` to the Git section**

In `lua/neon-genesis/init.lua`, in the `-- Git` section (around line 234), add before `h("DiffAdd", ...)` stays, insert after it:

```lua
	h("DiffChange", { fg = colors.yellow, bg = colors.none })
	h("DiffDelete", { fg = colors.red, bg = colors.none })
```

So the full Git section reads:

```lua
	-- Git
	h("DiffAdd", { fg = colors.green, bg = colors.none })
	h("DiffChange", { fg = colors.yellow, bg = colors.none })
	h("DiffDelete", { fg = colors.red, bg = colors.none })
	h("GitSignsAdd", { link = "DiffAdd" })
	h("GitSignsDelete", { link = "DiffDelete" })
	h("GitSignsChange", { link = "DiffChange" })
	h("DiffText", { fg = colors.blue, bg = colors.none, bold = true })
```

- [ ] **Step 2: Verify DiffChange and DiffDelete resolve to theme colors**

Run:
```bash
cd /home/lp2am/code/auto/neon-genesis
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').load()" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'DiffChange'})))" -c "qa" 2>&1
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').load()" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'DiffDelete'})))" -c "qa" 2>&1
```
Expected: `DiffChange` fg matches `#f1fa8c` (yellow), `DiffDelete` fg matches `#ff5555` (red).

- [ ] **Step 3: Add `PmenuSbar` and `PmenuThumb` to the Popup Menu section**

In `lua/neon-genesis/init.lua`, in the `-- Popup Menu` section (around line 117-120), add after `h("PmenuBorder", ...)`:

```lua
	h("PmenuSbar", { bg = colors.surface })
	h("PmenuThumb", { bg = colors.border })
```

- [ ] **Step 4: Verify Pmenu scrollbar groups**

```bash
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').load()" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'PmenuSbar'})))" -c "qa" 2>&1
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').load()" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'PmenuThumb'})))" -c "qa" 2>&1
```
Expected: `PmenuSbar` bg matches `#1c1c1c` (surface), `PmenuThumb` bg matches `#3e4452` (border).

- [ ] **Step 5: Commit**

```bash
cd /home/lp2am/code/auto/neon-genesis
git add lua/neon-genesis/init.lua
git commit -m "fix: define DiffChange/DiffDelete and add Pmenu scrollbar highlights"
```

---

### Task 2: Add `setup()` config API with style toggles

**Files:**
- Modify: `lua/neon-genesis/init.lua:1-33` (top of file, palette/override setup) and the `h()`-calling sections that use hardcoded bold/italic for comments, keywords, and functions.

- [ ] **Step 1: Add `M.setup()` and style-table resolution at the top of the file**

Replace the top of `lua/neon-genesis/init.lua` (lines 1-33) with:

```lua
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

-- vim.g.neon_genesis_config is set by M.setup() and, unlike module-local
-- state, survives the package.loaded cache-clear in colors/neon-genesis.lua
local config = vim.g.neon_genesis_config or {}

-- Override palette with user customizations (legacy mechanism, still supported)
if vim.g.neon_genesis_colors then
	for k, v in pairs(vim.g.neon_genesis_colors) do
		colors[k] = v
	end
end

-- setup({colors=...}) takes precedence over vim.g.neon_genesis_colors if both are set
if config.colors then
	for k, v in pairs(config.colors) do
		colors[k] = v
	end
end

local default_styles = {
	comments = { italic = true },
	keywords = { bold = true },
	functions = { bold = false },
}
local styles = vim.tbl_deep_extend("force", default_styles, config.styles or {})

local function h(group, opts)
	-- 0 means current buffer/global
	nvim_set_hl(0, group, opts)
end

function M.setup(opts)
	vim.g.neon_genesis_config = opts or {}
end
```

- [ ] **Step 2: Wire the `styles` table into the comment, keyword, and function highlight groups**

In `lua/neon-genesis/init.lua`, update these four highlight calls to read from `styles` instead of hardcoding:

`Comment` (Syntax section, ~line 132):
```lua
	h("Comment", { fg = colors.grey, italic = styles.comments.italic })
```

`Statement` and `Keyword` (Syntax section, ~lines 123-124):
```lua
	h("Statement", { fg = colors.cyan, bold = styles.keywords.bold })
	h("Keyword", { fg = colors.purple, bold = styles.keywords.bold }) -- EVA Purple
```

`Function` (Syntax section, ~line 125):
```lua
	h("Function", { fg = colors.cyan, bold = styles.functions.bold })
```

`@comment` (Treesitter section, ~line 178):
```lua
	h("@comment", { fg = colors.grey, italic = styles.comments.italic })
```

`@keyword` (Treesitter section, ~line 150):
```lua
	h("@keyword", { fg = colors.purple, bold = styles.keywords.bold })
```

`@function` (Treesitter section, ~line 144):
```lua
	h("@function", { fg = colors.cyan, bold = styles.functions.bold })
```

`@markup.quote` (Treesitter section, ~line 206):
```lua
	h("@markup.quote", { fg = colors.grey, italic = styles.comments.italic })
```

`LspInlayHint` (LSP section, ~line 231):
```lua
	h("LspInlayHint", { fg = colors.grey, italic = styles.comments.italic })
```

- [ ] **Step 3: Verify default behavior is unchanged (no setup() call)**

```bash
cd /home/lp2am/code/auto/neon-genesis
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').load()" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'Comment'})))" -c "qa" 2>&1
```
Expected: `italic = true` present, matching pre-change behavior.

- [ ] **Step 4: Verify `setup()` style override works and survives the cache-clear reload**

```bash
cd /home/lp2am/code/auto/neon-genesis
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').setup({styles = {comments = {italic = false}}})" -c "colorscheme neon-genesis" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'Comment'})))" -c "qa" 2>&1
```
Expected: `italic` is `false` or absent (not `true`) — confirms `setup()` config survived `colors/neon-genesis.lua`'s `package.loaded['neon-genesis'] = nil` cache-clear before `M.load()` ran.

- [ ] **Step 5: Verify `setup()` color override still works**

```bash
cd /home/lp2am/code/auto/neon-genesis
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').setup({colors = {cyan = '#ff00ff'}})" -c "colorscheme neon-genesis" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = 'Statement'})))" -c "qa" 2>&1
```
Expected: `fg` matches `#ff00ff`.

- [ ] **Step 6: Commit**

```bash
cd /home/lp2am/code/auto/neon-genesis
git add lua/neon-genesis/init.lua
git commit -m "feat: add setup() config API with comment/keyword/function style toggles"
```

---

### Task 3: Add lualine.nvim theme

**Files:**
- Create: `lua/lualine/themes/neon-genesis.lua`

- [ ] **Step 1: Write the theme file**

```lua
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
```

- [ ] **Step 2: Verify the theme file loads and is well-formed**

```bash
cd /home/lp2am/code/auto/neon-genesis
nvim --headless --clean -u NONE -c "set rtp+=." -c "lua print(vim.inspect(require('lualine.themes.neon-genesis')))" -c "qa" 2>&1
```
Expected: prints a table with `normal`, `insert`, `visual`, `replace`, `command`, `inactive` keys, no errors.

- [ ] **Step 3: Commit**

```bash
cd /home/lp2am/code/auto/neon-genesis
git add lua/lualine/themes/neon-genesis.lua
git commit -m "feat: add lualine.nvim theme"
```

---

### Task 4: Add mini.statusline, noice.nvim, trouble.nvim, mason.nvim, snacks.nvim, and flash.nvim highlights

**Files:**
- Modify: `lua/neon-genesis/init.lua` (append after the existing `-- LSP Semantic Tokens` section, i.e. after the last `h(...)` call, before `end` at line ~369)

- [ ] **Step 1: Append all six plugin sections**

Add before the final `end` in `M.load()`:

```lua
	-- Plugins: mini.statusline
	h("MiniStatuslineModeNormal", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("MiniStatuslineModeInsert", { fg = colors.dark, bg = colors.green, bold = true })
	h("MiniStatuslineModeVisual", { fg = colors.dark, bg = colors.purple, bold = true })
	h("MiniStatuslineModeReplace", { fg = colors.dark, bg = colors.red, bold = true })
	h("MiniStatuslineModeCommand", { fg = colors.dark, bg = colors.yellow, bold = true })
	h("MiniStatuslineModeOther", { fg = colors.dark, bg = colors.blue, bold = true })
	h("MiniStatuslineDevinfo", { fg = colors.white, bg = colors.surface })
	h("MiniStatuslineFilename", { fg = colors.grey, bg = colors.none })
	h("MiniStatuslineFileinfo", { fg = colors.white, bg = colors.surface })
	h("MiniStatuslineInactive", { fg = colors.grey, bg = colors.none })

	-- Plugins: noice.nvim
	h("NoiceCmdlinePopup", { link = "NormalFloat" })
	h("NoiceCmdlinePopupBorder", { link = "FloatBorder" })
	h("NoiceCmdlineIcon", { fg = colors.cyan })
	h("NoiceMini", { link = "NormalFloat" })
	h("NoicePopupmenu", { link = "Pmenu" })
	h("NoicePopupmenuBorder", { link = "FloatBorder" })
	h("NoicePopupmenuSelected", { link = "PmenuSel" })

	-- Plugins: trouble.nvim
	h("TroubleNormal", { fg = colors.white, bg = colors.none })
	h("TroubleText", { fg = colors.white })
	h("TroubleCount", { fg = colors.cyan, bold = true })
	h("TroubleIndent", { fg = colors.border })
	h("TroubleFoldIcon", { fg = colors.grey })
	h("TroubleTextError", { link = "DiagnosticError" })
	h("TroubleTextWarning", { link = "DiagnosticWarn" })
	h("TroubleTextInformation", { link = "DiagnosticInfo" })
	h("TroubleTextHint", { link = "DiagnosticHint" })

	-- Plugins: mason.nvim
	h("MasonHeader", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("MasonHighlight", { fg = colors.cyan })
	h("MasonHighlightBlock", { fg = colors.dark, bg = colors.cyan })
	h("MasonHighlightBlockBold", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("MasonMuted", { fg = colors.grey })
	h("MasonMutedBlock", { fg = colors.white, bg = colors.surface })
	h("MasonHighlightBlockGreen", { fg = colors.dark, bg = colors.green })
	h("MasonMutedBlockGreen", { fg = colors.green, bg = colors.surface })
	h("MasonHighlightBlockRed", { fg = colors.dark, bg = colors.red })

	-- Plugins: snacks.nvim
	h("SnacksDashboardHeader", { fg = colors.cyan, bold = true })
	h("SnacksDashboardIcon", { fg = colors.cyan })
	h("SnacksDashboardDesc", { fg = colors.white })
	h("SnacksDashboardKey", { fg = colors.purple })
	h("SnacksDashboardFooter", { fg = colors.grey, italic = true })
	h("SnacksNotifierError", { link = "DiagnosticError" })
	h("SnacksNotifierWarn", { link = "DiagnosticWarn" })
	h("SnacksNotifierInfo", { link = "DiagnosticInfo" })
	h("SnacksNotifierDebug", { link = "DiagnosticHint" })
	h("SnacksNotifierTrace", { fg = colors.grey })

	-- Plugins: flash.nvim
	h("FlashLabel", { fg = colors.dark, bg = colors.cyan, bold = true })
	h("FlashMatch", { fg = colors.white, bg = colors.selection })
	h("FlashCurrent", { fg = colors.dark, bg = colors.green, bold = true })
	h("FlashBackdrop", { fg = colors.grey })
```

- [ ] **Step 2: Verify a representative group from each new plugin section**

```bash
cd /home/lp2am/code/auto/neon-genesis
for g in MiniStatuslineModeNormal NoiceCmdlineIcon TroubleCount MasonHeader SnacksDashboardHeader FlashLabel; do
  echo "== $g =="
  nvim --headless --clean -u NONE -c "set rtp+=." -c "lua require('neon-genesis').load()" -c "lua print(vim.inspect(vim.api.nvim_get_hl(0, {name = '$g'})))" -c "qa" 2>&1
done
```
Expected: each prints a non-empty highlight table (no "Invalid highlight name" errors, no empty `{}`).

- [ ] **Step 3: Commit**

```bash
cd /home/lp2am/code/auto/neon-genesis
git add lua/neon-genesis/init.lua
git commit -m "feat: add highlight support for mini.statusline, noice, trouble, mason, snacks, flash"
```

---

### Task 5: Update README.md and AGENTS.md

**Files:**
- Modify: `README.md` (Supported Plugins list, Customization section)
- Modify: `AGENTS.md` (Currently supported plugins list)

- [ ] **Step 1: Update README.md's "Supported Plugins" list**

Add these seven entries to the bulleted list in the `## 🔌 Supported Plugins` section:

```markdown
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [mini.statusline](https://github.com/echasnovski/mini.statusline)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
- [flash.nvim](https://github.com/folke/flash.nvim)
```

- [ ] **Step 2: Add a `setup()` usage example to README.md's Customization section**

In the `## 🎨 Customization` section, after the existing `vim.g.neon_genesis_colors` example, add:

````markdown
Alternatively, use `setup()` to configure both colors and style toggles:

```lua
require("neon-genesis").setup({
    colors = {
        cyan = "#00ffff",
    },
    styles = {
        comments = { italic = false },
        keywords = { bold = true },
        functions = { bold = true },
    },
})

vim.cmd.colorscheme("neon-genesis")
```
````

- [ ] **Step 3: Update AGENTS.md's "Currently supported plugins" list**

In `AGENTS.md`, add the same seven plugins to the "Currently supported plugins" bulleted list.

- [ ] **Step 4: Commit**

```bash
cd /home/lp2am/code/auto/neon-genesis
git add README.md AGENTS.md
git commit -m "docs: document setup() API and new plugin support in README/AGENTS"
```

---

### Task 6: Add `doc/neon-genesis.txt` vim help file

**Files:**
- Create: `doc/neon-genesis.txt`

- [ ] **Step 1: Write the help file**

```text
*neon-genesis.txt*  A high-contrast, cyberpunk-inspired colorscheme for Neovim

==============================================================================
CONTENTS                                                *neon-genesis-contents*

    1. Introduction ........... |neon-genesis-introduction|
    2. Installation ........... |neon-genesis-installation|
    3. Usage ................... |neon-genesis-usage|
    4. Configuration ........... |neon-genesis-configuration|
    5. Supported Plugins ....... |neon-genesis-plugins|

==============================================================================
1. Introduction                                     *neon-genesis-introduction*

neon-genesis.nvim is a high-contrast, cyberpunk-inspired colorscheme for
Neovim with built-in transparency support.

==============================================================================
2. Installation                                     *neon-genesis-installation*

Using lazy.nvim: >lua
    {
        "lpbborges/neon-genesis",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("neon-genesis")
        end,
    }
<
==============================================================================
3. Usage                                                   *neon-genesis-usage*

Load the colorscheme with: >vim
    :colorscheme neon-genesis
<
Or from Lua: >lua
    vim.cmd.colorscheme("neon-genesis")
<
This theme does not set 'termguicolors' — enable it yourself: >lua
    vim.o.termguicolors = true
<
==============================================================================
4. Configuration                                   *neon-genesis-configuration*

Override palette colors and style toggles via `setup()`: >lua
    require("neon-genesis").setup({
        colors = {
            cyan = "#00ffff",
        },
        styles = {
            comments = { italic = false },
            keywords = { bold = true },
            functions = { bold = true },
        },
    })

    vim.cmd.colorscheme("neon-genesis")
<
`styles` fields and their defaults:
    comments.italic     default: true
    keywords.bold       default: true
    functions.bold      default: false

Palette colors may also be overridden via a global variable, set before
`colorscheme` is called: >lua
    vim.g.neon_genesis_colors = {
        cyan = "#00ffff",
    }
<
==============================================================================
5. Supported Plugins                                     *neon-genesis-plugins*

    - Telescope
    - nvim-cmp
    - nvim-tree
    - neo-tree
    - indent-blankline
    - which-key
    - Lazy.nvim
    - GitSigns
    - LazyGit
    - blink.cmp
    - lualine.nvim
    - mini.statusline
    - noice.nvim
    - trouble.nvim
    - mason.nvim
    - snacks.nvim
    - flash.nvim

==============================================================================
vim:tw=78:ts=8:ft=help:norl:
```

- [ ] **Step 2: Generate help tags and verify `:help neon-genesis` resolves**

```bash
cd /home/lp2am/code/auto/neon-genesis
nvim --headless --clean -u NONE -c "set rtp+=." -c "helptags doc" -c "qa" 2>&1
nvim --headless --clean -u NONE -c "set rtp+=." -c "help neon-genesis" -c "qa" 2>&1
```
Expected: no "E149: Sorry, no help for..." error.

- [ ] **Step 3: Commit**

```bash
cd /home/lp2am/code/auto/neon-genesis
git add doc/neon-genesis.txt doc/tags
git commit -m "docs: add vim help file"
```

---

### Task 7: Add CONTRIBUTING.md

**Files:**
- Create: `CONTRIBUTING.md`

- [ ] **Step 1: Write the file**

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
cd /home/lp2am/code/auto/neon-genesis
git add CONTRIBUTING.md
git commit -m "docs: add CONTRIBUTING.md"
```

---

## Final verification

- [ ] **Full headless smoke test — load the colorscheme with no errors**

```bash
cd /home/lp2am/code/auto/neon-genesis
nvim --headless --clean -u NONE -c "set rtp+=." -c "colorscheme neon-genesis" -c "qa" 2>&1
```
Expected: no output (no errors).

- [ ] **Confirm git log shows all commits from this plan**

```bash
cd /home/lp2am/code/auto/neon-genesis
git log --oneline -10
```
