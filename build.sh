#!/usr/bin/env bash
#
# Build the static HTML site from the markdown docs.
#   - converts each .md with pandoc using site/_template.html
#   - rewrites internal .md links to .html
#   - outputs into site/ (what Vercel serves)
#
# Usage:  bash build.sh
# Requires: pandoc

set -euo pipefail
cd "$(dirname "$0")"

OUT="site"
TEMPLATE="$OUT/_template.html"

# md source  ->  output html        ->  active-nav flag
build() {
  local src="$1" out="$2" flag="$3"
  pandoc "$src" \
    --from gfm \
    --to html5 \
    --standalone \
    --template "$TEMPLATE" \
    --metadata title:"$4" \
    -V "$flag" \
    --output "$OUT/$out"
  # rewrite internal doc links from .md to .html
  perl -pi -e 's/(href="(?:\.\/)?[\w-]+)\.md/$1.html/g' "$OUT/$out"
  echo "  built $OUT/$out"
}

echo "Building site/ from markdown…"
# copy example files so in-page links to them resolve on the hosted site
rm -rf "$OUT/examples" && cp -R examples "$OUT/examples"
build README.md                  index.html                   a_home    "Overview"
build 01-install.md              01-install.html              a_install "Install"
build 02-nvim-setup.md           02-nvim-setup.html           a_nvim    "Neovim setup"
build 03-cmux-setup.md           03-cmux-setup.html           a_cmux    "cmux setup"
build 04-running-code-with-uv.md 04-running-code-with-uv.html a_run     "Running code with uv"
echo "Done. Open site/index.html or deploy the repo to Vercel."
