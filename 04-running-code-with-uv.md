# 04 — Running code with uv

This is the core loop: write a Python file and run it. We do it two ways —
first in the plain terminal so you understand what's happening, then from inside
Neovim with one keypress.

There's a ready-made file to practice on: [`examples/hello.py`](./examples/hello.py).

---

## Part A — run it in the terminal

Open a terminal in cmux and `cd` into this directory:

```sh
cd ~/code/lab/stuff_nvim
```

### 1. Look at the file

`examples/hello.py` contains:

```python
def main():
    print("hello world")


if __name__ == "__main__":
    main()
```

### 2. Run it with uv

```sh
uv run examples/hello.py
```

You should see:

```
hello world
```

That's it. `uv run <file>` figures out the Python interpreter (downloading one
the first time if needed), then executes the file. No virtualenv to activate, no
`python3` vs `python` confusion.

### 3. Make your own and run it

```sh
echo 'print("hi from my own file")' > scratch.py
uv run scratch.py
```

### What `uv run` actually does

- Finds (or downloads) a Python interpreter.
- If the project has a `pyproject.toml`/lockfile, it installs those deps into a
  managed environment first.
- Runs your file in that environment.

For a standalone script that needs a package, you can declare it inline and uv
will fetch it on the fly:

```sh
uv run --with requests examples/hello.py
```

---

## Part B — run it from inside Neovim

This is what `<leader>ur` is for. (Leader = **Space**.)

### 1. Open the file

```sh
nvim examples/hello.py
```

### 2. Press the runner keymap

In normal mode, press:

```
<space>ur
```

That runs this mapping from `~/.config/nvim/lua/config/keymaps.lua`:

```lua
vim.keymap.set("n", "<leader>ur",
  ":belowright split | terminal uv run %<CR>i",
  { desc = "Run current file with uv" })
```

Step by step, it:

1. `belowright split` — opens a new window below the current one.
2. `terminal uv run %` — runs `uv run` on `%` (the current file's path) in that split.
3. `<CR>i` — confirms and drops you into terminal insert mode so you can interact.

You'll see `hello world` print in the bottom split.

### 3. Close the output split

When you're done reading the output:

- Press `<space>j` to toggle the terminal split closed (and back open), **or**
- `<space>q` to close the current split.

> Note: `<leader>q` is mapped to close-split in normal usage, and also to
> "show diagnostics" in LSP contexts — see `KEYBINDINGS.txt`. To just dismiss a
> terminal split, `<leader>j` (toggle terminal) is the cleanest.

### The terminal toggle (`<leader>j`)

Independent of the runner, `<space>j` toggles a persistent terminal split. It
reuses one terminal buffer, so your shell history stays put. Handy for running
`uv run` manually, git commands, etc., without leaving the editor.

---

## Part C — a real example: linear regression

Printing "hello world" proves the loop works. Here's something you'd actually
run: a classic **simple linear regression**, the workhorse of intro statistics.

The file is [`examples/regression.py`](./examples/regression.py). It uses
scikit-learn's built-in **diabetes** dataset and fits one predictor — **BMI** —
against a measure of disease progression. One predictor keeps it readable: you
can interpret the slope directly.

### The neat part: uv installs the dependencies for you

This script needs `scikit-learn` and `numpy`. You don't pip-install anything —
the file *declares its own dependencies* in a header block that uv reads:

```python
# /// script
# requires-python = ">=3.11"
# dependencies = ["scikit-learn", "numpy"]
# ///
```

That's the [PEP 723](https://peps.python.org/pep-0723/) inline-script format. uv
sees it, builds a temporary environment with those packages, and runs the file.

### Run it

```sh
uv run examples/regression.py
```

The first run downloads the packages (a few seconds); after that they're cached.
You'll see:

```
Fitted line:  y = 152.1 + 949.4 * bmi
R²         :  0.344

Interpretation:
  • Each +1 standardized unit of BMI is associated with about
    949 more units of disease progression.
  • BMI alone explains 34.4% of the variation in the outcome —
    real, but far from the whole story (that's why models add features).
```

### What the code does, step by step

1. **Load** the dataset (`load_diabetes`) and pick the BMI column.
2. **Fit** `LinearRegression().fit(X, y)` — finds the line `y = intercept + slope·bmi`.
3. **Score** it with R² — the fraction of the outcome's variation the line explains.
4. **Interpret** the slope and R² in plain language.

### Reading the result

- **Slope (949.4):** the line's steepness. Because sklearn's features are
  standardized (mean 0), this is "per standardized unit of BMI," not per raw BMI
  point — a detail worth knowing so you don't over-claim.
- **R² (0.344):** BMI alone explains ~34% of the variation. That's a genuine
  signal but leaves most unexplained — the natural motivation for adding more
  predictors (multiple regression).

You can run this from inside Neovim the same way as any file: open it and press
`<space>ur`.

---

## Cheat sheet

| What | How |
|------|-----|
| Run a file in the terminal | `uv run path/to/file.py` |
| Run a file + a one-off package | `uv run --with <pkg> file.py` |
| Run a script with inline deps | `uv run examples/regression.py` (deps in the `# /// script` header) |
| Run the **current** file from Neovim | `<space>ur` |
| Toggle a terminal inside Neovim | `<space>j` |
| Run a cargo (Rust) project | `<space>c` |

## Common gotchas

- **`uv: command not found`** — restart your shell after installing uv, or check
  that `~/.local/bin` is on your `PATH`.
- **`<leader>ur` does nothing** — make sure you're in *normal* mode (press `Esc`
  first) and that the buffer is a saved file (`%` needs a real path).
- **Wrong Python version** — pin one per project with `uv python pin 3.13`, or
  add a `pyproject.toml` with a `requires-python` field.
