# Architecture

Command V is a small Swift command-line helper, not an App Store app.

## Runtime Model

`command-v run` starts a foreground pasteboard monitor. The install command registers the same process as a per-user LaunchAgent:

```text
~/Library/LaunchAgents/dev.commandv.service.plist
```

The monitor polls `NSPasteboard.general.changeCount`. It does not install a keyboard hook, event tap, Finder extension, or Accessibility automation.

## Pasteboard Flow

When the clipboard changes:

1. If the pasteboard already contains a file URL, Command V skips it.
2. If the pasteboard contains image data, Command V materializes a PNG under `~/Library/Caches/CommandV/ClipboardImages`.
3. It restores the original pasteboard items.
4. It appends a file URL for the generated PNG.

Finder can then paste the image file with its normal `Cmd+V` behavior.

## Security Posture

The helper is local-only and has no network code. It stores only generated PNG files required for Finder paste. It does not maintain a clipboard history database.

The first public release should be distributed through GitHub and Homebrew. A signed and notarized binary can be added later to avoid Gatekeeper warnings for non-technical users.
