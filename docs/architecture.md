# Architecture

Ember has a native SwiftUI shell and a statically linked Rust core. The first
milestone establishes a real bridge and build loop. It does not launch games.

## Responsibilities

- **Ember:** Mac scenes, navigation, appearance preferences, and display state.
- **EmberKit:** Typed Swift models and one entry point for reading core state.
- **CEmberCore:** The handwritten C header imported by SwiftPM.
- **ember-ffi:** A small exported C ABI. It owns Rust allocations and contains
  unwinding panics at the snapshot boundary.
- **ember-core:** Platform-independent state and game-profile validation.

## Bridge contract, version 1

`ember_core_snapshot_json()` returns an owned, null-terminated UTF-8 JSON string.
It returns null on a recoverable failure or caught unwind. Swift copies the data,
decodes the schema, checks `bridgeApiVersion`, and uses `defer` to release the
allocation through `ember_core_string_free()` even if decoding fails.

Callers must free each returned allocation exactly once through that function.
Do not free it using Swift, retain it after release, or pass foreign pointers to
the Rust deallocator. Null is accepted by the free function. The current call is
small and synchronous; future downloads and process management must execute
away from SwiftUI's main actor.

The C header and Rust exports must change together. The Swift integration test
links the real Rust static library and exercises allocation, decoding, schema
compatibility, and release repeatedly.

## Build

The root Cargo workspace contains two crates. `script/build.sh` builds the Rust
static library into `.build/rust/debug`, then builds the executable in `macOS/`.
The Swift manifest derives the link path from its own location, so it does not
depend on the developer's checkout path. The build scripts set the Rust macOS
deployment target to 14.0 to match SwiftPM.

`script/build_and_run.sh` stages a local `.app`, generates its Info.plist, signs
it ad hoc, and launches the bundle. This signature is for local development;
release signing and notarization are separate future work. No compatibility
runtime is downloaded by the build scripts.

## Game profiles

`profiles/catalog.json` is embedded at Rust compile time. Schema version 1 accepts
only a catalog version and entries with positive Steam App IDs and non-empty
names. Duplicate IDs and unknown fields are rejected. The initial catalog is
empty because no game has been tested.

Backend versions, chip-specific settings, and benchmark records will be added
after real game testing informs their data model. Profile names and IDs are
data, never shell commands.

## Runtime integration, planned

The app will orchestrate existing macOS-compatible Wine and graphics components.
It will not port Linux Proton wholesale or rewrite graphics translation in Rust.
Keep game installation and launching inside Steam so ownership, updates, and
Steam-specific behavior use the normal client flow.

Before runtime installation ships, establish a pinned manifest, verified
downloads, safe archive extraction, license/source notices, cancellable work,
explicit process arguments without shell interpolation, and rollback behavior.
Persistent data should live under the user's Application Support directory,
with runtime binaries kept separate from game saves and Steam credentials.

The launcher language does not determine game FPS. Measure and optimize the
compatibility stack and per-game configuration before making performance claims.

## Command Line Tools compatibility

The UI uses a `ViewState` alias for SwiftUI's public `State` property wrapper.
The macOS 27 SDK also exports a `State` macro, but the local Command Line Tools
installation does not provide its `SwiftUIMacros` plugin. The alias selects the
existing wrapper without requiring that plugin and also works with older SDKs.
Bridge tests use Swift Testing, which is included with the Swift 6 toolchain.
