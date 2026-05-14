# Architecture

cmd-v is a small Swift command-line helper, not an App Store app.

## Compatibility

The Swift package declares macOS 12 as its deployment target. Source builds require Swift 6 / Xcode 16 or newer. Current CI builds and tests on GitHub Actions `macos-15`; local development has been tested on macOS 26.4.1. Older macOS versions are likely to work but are not verified.

## Runtime Model

`cmd-v run` starts a foreground pasteboard monitor. The install command registers the same process as a per-user LaunchAgent:

```text
~/Library/LaunchAgents/io.github.serkanemir.cmdv.plist
```

The monitor polls `NSPasteboard.general.changeCount`. It does not install a keyboard hook, event tap, Finder extension, or Accessibility automation.

## Pasteboard Flow

When the clipboard changes:

1. If the pasteboard already contains a file URL, cmd-v skips it.
2. If the pasteboard contains image data, cmd-v materializes a PNG under `~/Library/Caches/cmd-v/ClipboardImages`.
3. It verifies that the pasteboard has not changed while the PNG was being generated.
4. It rewrites the pasteboard with a normalized image item.
5. It appends a file URL for the generated PNG.

Finder can then paste the image file with its normal `Cmd+V` behavior.

cmd-v does not preserve arbitrary pasteboard types. This is intentional: source HTML, source URLs, and app-private metadata are excluded to keep the clipboard surface small and predictable.

## Storage

Generated files live in:

```text
~/Library/Caches/cmd-v/ClipboardImages
```

The cache directory is `0700`. Generated PNG files are `0600`. Files above 100 MB are rejected before writing.

If the clipboard changes during conversion, the generated cache file is removed and the newer clipboard contents are left alone.

## Security Posture

The helper is local-only and has no network code. It stores only generated PNG files required for Finder paste. It does not maintain a clipboard history database.

The public release is distributed through GitHub and Homebrew. A signed and notarized binary can be added in a later release to avoid Gatekeeper warnings for non-technical users.
