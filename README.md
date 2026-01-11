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

## 📦 Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim) (Recommended)

```lua
{
    "lpbborges/neon-genesis",
    lazy = false, -- Load immediately to avoid flash of unstyled content
    priority = 1000, -- Load before all other plugins
    config = function()
        vim.cmd.colorscheme("neon-genesis")
    end,
}
