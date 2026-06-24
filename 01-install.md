# 01 — Install everything

Goal: take a fresh macOS machine and end up with Neovim, cmux, and uv installed.
Everything here is run in a terminal (the built-in **Terminal.app** is fine until
cmux is installed).

## TL;DR — one command

If you just want everything set up from the get-go, run the bundled script. It's
idempotent (safe to re-run) and skips anything already installed:

```sh
bash setup.sh
```

Or straight from the web without cloning first:

```sh
curl -fsSL https://raw.githubusercontent.com/<you>/stuff_nvim/main/setup.sh | bash
```

It installs Homebrew, Neovim, cmux, and uv, then clones my Neovim config to
`~/.config/nvim`. The rest of this page explains each step if you'd rather do it
by hand or something goes wrong.

## 1. Homebrew (the package manager)

Homebrew is how I install most things on macOS. Check if it's already there:

```sh
brew --version
```

If that errors, install it:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

After it finishes, follow the printed instructions to add `brew` to your `PATH`
(on Apple Silicon it lives at `/opt/homebrew/bin/brew`).

## 2. Neovim (the editor)

```sh
brew install neovim
nvim --version   # expect v0.12.0 or newer
```

> My config targets Neovim **0.12+**. Older versions may break plugins.

## 3. cmux (the terminal app)

cmux is a desktop app, so install it as a cask:

```sh
brew install --cask cmux
```

It installs to `/Applications/cmux.app`. Launch it once so it creates its config
directory at `~/.config/cmux`.

## 4. uv (the Python runner)

uv replaces `python`, `pip`, and `virtualenv` for day-to-day work. It manages
Python versions *and* runs scripts.

```sh
curl -LsSf https://astral.sh/uv/install.sh | sh
```

This installs to `~/.local/bin/uv`. Restart your shell, then verify:

```sh
uv --version    # expect 0.6.5 or newer
```

uv will download a Python interpreter for you the first time you need one — you
don't have to install Python separately.

## 5. My Neovim config

The editor is configured via a git repo at `~/.config/nvim`. To get my exact
setup on a new machine:

```sh
git clone https://github.com/heyodog0/nvim.git ~/.config/nvim
nvim
```

On first launch, `init.lua` bootstraps the **lazy.nvim** plugin manager and
installs every plugin automatically. Let it finish, then quit and reopen.

> `~/.config/nvim` is its own git repository on this machine — that's where the
> config is version-controlled, not in this `stuff_nvim` directory.

## Verify the whole stack

```sh
nvim --version | head -1
cmux --version
uv --version
```

If all three print versions, you're ready for
[04 — Running code with uv](./04-running-code-with-uv.md).
