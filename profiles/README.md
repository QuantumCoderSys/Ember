# Game catalog

`catalog.json` is a versioned, compile-time catalog. It is intentionally empty.
An entry identifies a testing target; it does not establish that the game works.

Schema version 1:

```json
{
  "schemaVersion": 1,
  "profiles": [
    { "appId": 42, "name": "Example only — not a tested game" }
  ]
}
```

The example is illustrative and is not included in the bundled catalog. IDs must
be positive, names must contain non-whitespace text, and duplicate IDs and
unknown fields are rejected. Runtime and benchmark fields will be designed
around the first real testing results.
