# Roadmap

## 0. Foundation — current

Build and launch a native Mac app that reads real state from a Rust core. Verify
the FFI boundary through Rust and Swift integration tests. Publish an honest,
reproducible source repository.

## 1. Compatibility runtime

Select a maintained macOS-compatible Wine build and evaluate graphics backends
against the first target games. Record component licenses, redistribution
conditions, source obligations, supported Macs, and hashes. Implement verified
installation, failure recovery, version pinning, and rollback.

Done when a clean development machine can install, verify, and remove a chosen
runtime without losing user data, and failures leave a recoverable state.

## 2. Steam

Install and launch Windows Steam in an isolated environment. Keep login inside
Steam; Ember should not collect Steam passwords. Handle client startup, exit,
updates, and useful redacted diagnostics.

Done when a user can sign in, install an owned test game, launch it through
Steam, quit, restart the app, and launch again.

## 3. First tested games

Choose 5–10 games that already show promise on the selected stack. Start with
single-player games; investigate online services and anti-cheat separately.
Record game versions and exact Mac specifications. Test more than the main menu:
gameplay, audio, input, saves, relaunch, and Steam features used by the title.

Done when published profiles have repeatable test evidence and disclose known
limitations. Define compatibility labels from that evidence before publishing
ratings.

## 4. Measured optimization

Benchmark repeatable scenes with fixed resolution, graphics settings, and
hardware. Track average FPS, low-percentile behavior, frame times, sustained
performance, and rendering correctness. Distinguish a better default from a
runtime code improvement.

Done when applying a profile produces a documented, repeatable benefit against
the baseline without unacceptable regressions.

## 5. Public builds

Add distribution signing, notarization, releases, update verification, and a
documented runtime maintenance process. Exercise upgrades and rollback on Macs
other than the development machine before calling a release stable.
