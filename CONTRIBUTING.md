# Contributing to Ember

Start with the setup instructions in the README. Keep changes focused on the
Steam-only, Apple-silicon-first product scope.

Before submitting a change:

```sh
./script/check.sh
```

For interface changes, also launch the app with `./script/build_and_run.sh`
and exercise the changed flow in light and dark appearance.

Keep Rust logic in `ember-core`, C ABI ownership in `ember-ffi`, Swift bridge
decoding in `EmberKit`, and interface code in the `Ember` executable. Prefer
system Mac controls and small, named views. Do not introduce a web runtime
or a second app framework without discussing the architectural change.

Never commit Steam credentials, game files, downloaded compatibility runtimes,
build output, signing identities, or personal diagnostic data. Game-profile
entries are not proof of compatibility. Future compatibility reports should
record the game build, runtime/backend versions, Mac chip, RAM, macOS version,
graphics settings, tested gameplay, and reproducible benchmark method.

Use issues to propose substantial runtime or graphics changes before doing a
large implementation. Performance claims need before/after measurements on
the same hardware and workload, including frame-time behavior.
