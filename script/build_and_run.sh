#!/usr/bin/env bash
set -euo pipefail

EMBER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EMBER_MODE="${1:-run}"
EMBER_BUNDLE="$EMBER_ROOT/dist/Ember.app"
EMBER_EXECUTABLE="$EMBER_BUNDLE/Contents/MacOS/Ember"

case "$EMBER_MODE" in
  run|--debug|--logs|--telemetry|--verify) ;;
  *) echo "usage: $0 [run|--debug|--logs|--telemetry|--verify]" >&2; exit 2 ;;
esac

# Match only this project's staged executable, never other apps named Ember.
if [ -x "$EMBER_EXECUTABLE" ]; then
  /usr/bin/pkill -f "^${EMBER_EXECUTABLE}$" >/dev/null 2>&1 || true
fi

"$EMBER_ROOT/script/build.sh"
EMBER_BIN_DIR="$(swift build --package-path "$EMBER_ROOT/macOS" --show-bin-path)"
mkdir -p "$EMBER_BUNDLE/Contents/MacOS"
cp "$EMBER_BIN_DIR/Ember" "$EMBER_EXECUTABLE"
chmod +x "$EMBER_EXECUTABLE"

cat > "$EMBER_BUNDLE/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key><string>Ember</string>
  <key>CFBundleIdentifier</key><string>io.github.quantumcodersys.ember</string>
  <key>CFBundleName</key><string>Ember</string>
  <key>CFBundleDisplayName</key><string>Ember</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>0.1.0</string>
  <key>CFBundleVersion</key><string>1</string>
  <key>LSMinimumSystemVersion</key><string>14.0</string>
  <key>NSPrincipalClass</key><string>NSApplication</string>
  <key>NSHighResolutionCapable</key><true/>
</dict>
</plist>
PLIST

# Local development signature. Distribution signing/notarization comes later.
/usr/bin/codesign --force --sign - "$EMBER_BUNDLE"

case "$EMBER_MODE" in
  run)
    /usr/bin/open -n "$EMBER_BUNDLE"
    ;;
  --debug)
    /usr/bin/lldb -- "$EMBER_EXECUTABLE"
    ;;
  --logs)
    /usr/bin/open -n "$EMBER_BUNDLE"
    /usr/bin/log stream --info --style compact --predicate 'process == "Ember"'
    ;;
  --telemetry)
    /usr/bin/open -n "$EMBER_BUNDLE"
    /usr/bin/log stream --info --style compact --predicate 'subsystem == "io.github.quantumcodersys.ember"'
    ;;
  --verify)
    /usr/bin/open -n "$EMBER_BUNDLE"
    for ember_attempt in 1 2 3 4 5; do
      if /usr/bin/pgrep -f "^${EMBER_EXECUTABLE}$" >/dev/null; then
        echo "Ember launched: $EMBER_BUNDLE"
        exit 0
      fi
      sleep 1
    done
    echo "Ember did not remain running after launch." >&2
    exit 1
    ;;
esac
