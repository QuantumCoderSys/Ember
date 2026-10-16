#!/usr/bin/env bash
set -euo pipefail

EMBER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$EMBER_ROOT"

if ! command -v cargo >/dev/null 2>&1; then
  echo "Rust is required. Install stable Rust with rustup or Homebrew, then retry." >&2
  exit 1
fi

# Both languages use the host architecture; cross-compilation is not supported yet.
MACOSX_DEPLOYMENT_TARGET=14.0 cargo build --locked --package ember-ffi --target-dir "$EMBER_ROOT/.build/rust"
swift build --package-path "$EMBER_ROOT/macOS" --product Ember
