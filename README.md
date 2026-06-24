# stuff_nvim — my terminal coding setup

A one-stop shop for my coding environment: **Neovim** for editing, **cmux** as
the terminal, and **uv** for running Python code. Start at the top and work down.

If you're setting this up on a fresh machine, read in order. If you just want to
remember how to run a file, jump to [04 — Running code with uv](./04-running-code-with-uv.md).

## The pieces

| Tool  | What it is                          | My version (2026-06-23) |
|-------|-------------------------------------|-------------------------|
| Neovim | The text editor                    | 0.12.0                  |
| cmux  | The terminal app (multiplexer)      | 0.64.16                 |
| uv    | Python package + script runner      | 0.6.5                   |
| Homebrew | macOS package manager I install with | 6.0.2                |

## Guides

1. **[Install everything](./01-install.md)** — get Homebrew, Neovim, cmux, and uv onto a fresh Mac.
2. **[Neovim setup](./02-nvim-setup.md)** — what lives in `~/.config/nvim` and how it's wired.
3. **[cmux setup](./03-cmux-setup.md)** — my `~/.config/cmux` tuning.
4. **[Running code with uv](./04-running-code-with-uv.md)** — hello world in the terminal, then from inside Neovim.

## The 30-second version

```
# install everything (once) — see 01-install.md
bash setup.sh

# write a file
echo 'print("hello world")' > hello.py

# run it in the terminal
uv run hello.py

# run it from inside Neovim
#   open the file, then press:  <space>ur
```

That's the whole loop. The rest of these docs explain each step.

---

*Building/hosting this as a site? See [HOSTING.md](./HOSTING.md).*
