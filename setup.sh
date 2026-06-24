#!/usr/bin/env bash
#
# One-shot setup for my terminal coding environment:
#   Homebrew -> Neovim, cmux -> uv -> my Neovim config
#
# Usage:
#   bash setup.sh
#
# Safe to re-run: every step checks whether the tool is already installed.

set -euo pipefail

NVIM_CONFIG_REPO="https://github.com/heyodog0/nvim.git"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$1"; }
ok()    { printf '\033[1;32m  ok\033[0m %s\n' "$1"; }
have()  { command -v "$1" >/dev/null 2>&1; }

# --- 1. Homebrew ---------------------------------------------------------------
if have brew; then
  ok "Homebrew already installed ($(brew --version | head -1))"
else
  info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script (Apple Silicon default location)
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# --- 2. Neovim -----------------------------------------------------------------
if have nvim; then
  ok "Neovim already installed ($(nvim --version | head -1))"
else
  info "Installing Neovim"
  brew install neovim
fi

# --- 3. cmux -------------------------------------------------------------------
if [ -d "/Applications/cmux.app" ]; then
  ok "cmux already installed"
else
  info "Installing cmux"
  brew install --cask cmux
fi

# --- 4. uv ---------------------------------------------------------------------
if have uv; then
  ok "uv already installed ($(uv --version))"
else
  info "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

# --- 5. Neovim config ----------------------------------------------------------
if [ -d "$HOME/.config/nvim/.git" ]; then
  ok "Neovim config already present at ~/.config/nvim"
elif [ -e "$HOME/.config/nvim" ]; then
  info "~/.config/nvim exists but isn't my repo — leaving it alone"
else
  info "Cloning Neovim config"
  git clone "$NVIM_CONFIG_REPO" "$HOME/.config/nvim"
fi

# --- Done ----------------------------------------------------------------------
echo
info "Setup complete. Versions:"
have nvim && nvim --version | head -1
have cmux && cmux --version 2>/dev/null || [ -d /Applications/cmux.app ] && echo "cmux installed"
have uv   && uv --version
echo
info "Next: open Neovim once to let plugins install:  nvim"
info "Then try running code:  uv run examples/hello.py"
