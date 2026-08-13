# 🔷 neon-genesis.nvim

> "The fate of destruction is also the joy of rebirth."

**neon-genesis** is a high-contrast, cyberpunk-inspired colorscheme for Neovim. Blending the vivid neon palette of *Neon Genesis Evangelion*.

It features deep dark backgrounds, bright neon highlights for syntax, and built-in transparency support for a seamless terminal experience.

![Neovim Version](https://img.shields.io/badge/Neovim-0.9%2B-blueviolet.svg?style=flat-square)
![Lua](https://img.shields.io/badge/Written%20in-Lua-blue.svg?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-success.svg?style=flat-square)

## ✨ Features

* **⚡ Blazing Fast:** Pure Lua implementation using `vim.api.nvim_set_hl` with zero overhead.
* **🔮 Cyberpunk Palette:** Electric Cyans, EVA Purples, and Acid Greens.
* **🌫️ Transparent By Default:** Blends perfectly with your terminal background (Alacritty, Kitty, etc.).
* **🌳 Treesitter Support:** 100+ highlight groups including markdown (`@markup.*`) for rich, semantic syntax highlighting.
* **🔍 LSP Integration:** Diagnostic underlines, reference highlights, inlay hints, signature help, and semantic token highlighting.
* **🎛️ Terminal Colors:** Full 16-color ANSI palette for embedded terminal buffers.
* **🔌 Plugin Support:** First-class highlights for popular plugins (see below).

## 🎨 Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Cyan | `#00dede` | Functions, statements, operators |
| Green | `#28fa86` | Strings, types, booleans |
| Purple | `#bd93f9` | Keywords, special, attributes |
| Blue | `#61afef` | Constants, identifiers, properties |
| Red | `#ff5555` | Errors, deletions, exceptions |
| Yellow | `#f1fa8c` | Warnings, regex, git dirty |
| White | `#e4e4e4` | Default foreground |
| Grey | `#5c6370` | Comments, line numbers |
| Dark | `#080a10` | Deepest backgrounds |

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)

```lua
{
    "lpbborges/neon-genesis",
    lazy = false,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("neon-genesis")
    end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    "lpbborges/neon-genesis",
    config = function()
        vim.cmd.colorscheme("neon-genesis")
    end,
}
```

## 🎨 Customization

Override any palette color via `vim.g.neon_genesis_colors` in your Neovim config *before* loading the colorscheme:

```lua
vim.g.neon_genesis_colors = {
    cyan = "#00ffff",
    green = "#50fa7b",
    purple = "#c678dd",
}

vim.cmd.colorscheme("neon-genesis")
```

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

## 🔌 Supported Plugins

- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
- [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)
- [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim)
- [which-key](https://github.com/folke/which-key.nvim)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [GitSigns](https://github.com/lewis6991/gitsigns.nvim)
- [LazyGit](https://github.com/kdheepak/lazygit.nvim)
- [blink.cmp](https://github.com/Saghen/blink.cmp)
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [mini.statusline](https://github.com/echasnovski/mini.statusline)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [trouble.nvim](https://github.com/folke/trouble.nvim)
- [mason.nvim](https://github.com/williamboman/mason.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
- [flash.nvim](https://github.com/folke/flash.nvim)
