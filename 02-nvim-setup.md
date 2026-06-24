# 02 — Neovim setup

My config lives at `~/.config/nvim` and is its own git repo. It uses
**lazy.nvim** for plugins. Here's the layout and what each piece does.

## Directory layout

```
~/.config/nvim
├── init.lua              # entry point — bootstraps everything
├── KEYBINDINGS.txt       # printable cheatsheet of every keymap
├── lazy-lock.json        # pinned plugin versions
├── colors/
│   ├── ghostty.lua
│   └── moonfly-ghostty.lua   # my active colorscheme
└── lua/
    ├── config/
    │   ├── options.lua   # editor options (leader key, tabs, numbers…)
    │   ├── keymaps.lua   # all my keybindings + the code runner
    │   └── lsp.lua       # language server config
    └── plugins/          # one file per plugin area
        ├── telescope.lua    treesitter.lua   lsp.lua
        ├── git.lua          filetree.lua     editor.lua
        ├── ui.lua           trouble.lua      quarto.lua
        ├── r.lua            writing.lua      neorg.lua
```

## How it boots (`init.lua`)

1. Clones **lazy.nvim** into the data dir if it's missing.
2. Loads `config.options` (core settings).
3. Calls `lazy.setup("plugins")` — auto-loads every file in `lua/plugins/`.
4. Sets the `moonfly-ghostty` colorscheme.
5. Loads `config.keymaps` and `config.lsp`.

## Core options (`lua/config/options.lua`)

The settings worth knowing:

| Setting | Value | Why |
|---------|-------|-----|
| `mapleader` | `Space` | The leader key for all `<leader>` shortcuts |
| `maplocalleader` | `,` | Local leader (used by R/Quarto) |
| `number` + `relativenumber` | on | Hybrid line numbers |
| `expandtab`, `shiftwidth=2`, `tabstop=2` | | 2-space soft tabs |
| `ignorecase` + `smartcase` | on | Case-insensitive search unless you type a capital |
| `autoread` | on | Reload files changed on disk |
| `scrolloff` | 8 | Keep 8 lines of context around the cursor |
| `timeoutlen` | 200 | Fast key-chord timeout |

There's also an autocmd that hides the cursorline while you're inside a terminal
buffer and restores it when you leave — keeps the embedded terminal clean.

## Key plugins

- **telescope** — fuzzy finder (`<leader>ff` files, `<leader>fg` grep).
- **nvim-tree** — file tree sidebar (`<leader>n` toggle).
- **treesitter** — syntax-aware highlighting.
- **lsp** + `config/lsp.lua` — go-to-definition, hover, rename, code actions.
- **gitsigns** — gutter git markers + hunk navigation.
- **editor.lua** — quality-of-life: autopairs, indent guides, `Comment.nvim`,
  `mini.ai/surround/pairs`, and `flash` motions (`s` to jump anywhere).
- **r.lua / quarto.lua / neorg / writing** — for R, Quarto notebooks, and notes.

## The most-used keybindings

Leader is **Space**. Full list is in `~/.config/nvim/KEYBINDINGS.txt`; the ones I
reach for constantly:

| Key | Action |
|-----|--------|
| `<leader>n` | Toggle file tree |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>v` / `<leader>s` | Vertical / horizontal split |
| `<leader>j` | Toggle a terminal split (works from terminal mode too) |
| `<leader>ur` | **Run the current file with uv** |
| `<leader>c` | Run a cargo project |
| `gd` / `K` / `<leader>rn` | Go to definition / hover / rename |
| `s` | Flash jump to any visible spot |

The runner keymaps (`<leader>ur`, `<leader>c`) are the bridge to
[running code](./04-running-code-with-uv.md).
