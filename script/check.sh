#!/usr/bin/env bash
set -euo pipefail

EMBER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$EMBER_ROOT"

cargo fmt --all -- --check
cargo clippy --locked --workspace --all-targets -- -D warnings
cargo test --locked --workspace
"$EMBER_ROOT/script/build.sh"
swift test --package-path "$EMBER_ROOT/macOS"
