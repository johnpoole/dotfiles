#!/usr/bin/env bash
# dotfiles/setup.sh
# Run once on a new machine to create symlinks.
# Safe to re-run — skips links that already exist.

set -e
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local src="$1"
    local dst="$2"
    if [ -L "$dst" ]; then
        echo "  already linked: $dst"
    elif [ -e "$dst" ]; then
        echo "  SKIP: $dst exists and is not a symlink — move it manually first"
    else
        mkdir -p "$(dirname "$dst")"
        ln -s "$src" "$dst"
        echo "  linked: $dst -> $src"
    fi
}

echo "Setting up dotfiles from $DOTFILES"
echo

link "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"

echo
echo "Done."
