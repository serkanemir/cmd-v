# Contributing

cmd-v is intentionally small. Contributions should preserve that shape.

## Development

```bash
swift build
swift test
swift run cmd-v run
```

## Principles

- Keep the app local-only.
- Do not add telemetry, analytics, accounts, or network calls.
- Avoid dependencies unless the benefit is obvious and documented.
- Treat clipboard data as sensitive.
- Add tests for changes to pasteboard, cache, install, or security behavior.
- Keep the Finder `Cmd+V` flow simple.

## Before a Pull Request

```bash
swift test
```

Update `README.md`, `SECURITY.md`, or `docs/` when behavior changes.
