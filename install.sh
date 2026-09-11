#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

command -v stow >/dev/null 2>&1 || {
  echo "GNU Stow não encontrado. Instale com brew/apt/pacman antes de continuar." >&2
  exit 1
}

DRY_RUN=""
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY_RUN="-n"
fi

stow -v $DRY_RUN -t "$HOME" common

case "$(uname -s)" in
  Linux)
    stow -v $DRY_RUN -t "$HOME" linux
    ;;
  Darwin)
    stow -v $DRY_RUN -t "$HOME" macos
    ;;
  *)
    echo "SO não suportado: $(uname -s)" >&2
    exit 1
    ;;
esac
