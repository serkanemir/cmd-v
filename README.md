# Command V

Paste clipboard images into Finder as files with `Cmd+V`.

Command V is a tiny native macOS helper. When your clipboard contains an image, it prepares a temporary PNG file reference alongside the original image data. Finder can then use its normal `Cmd+V` behavior to paste that image into the current folder as a file.

## Why

macOS can copy screenshots directly to the clipboard, but Finder does not paste raw image clipboard data as a new file. Command V fills only that gap.

## Install

For now, build and install from source:

```bash
git clone https://github.com/serkanemir/cmd-v.git
cd cmd-v
./scripts/install.sh
```

This installs `command-v` to `~/.local/bin/command-v` and starts a per-user LaunchAgent.

## Use

1. Take a screenshot to the clipboard, for example `Ctrl+Cmd+Shift+4`.
2. Open Finder.
3. Press `Cmd+V`.

The pasted file is created from a cached PNG representation of the clipboard image.

## Commands

```bash
command-v status
command-v stop
command-v start
command-v restart
command-v doctor
command-v uninstall
```

For development:

```bash
swift run command-v run
swift run command-v convert
swift test
```

## Privacy

Command V is intentionally narrow:

- No clipboard history
- No telemetry
- No network calls
- No accounts
- No cloud sync
- No App Store dependency

It watches the pasteboard change count locally and only acts when the current clipboard contains image data and no existing file reference.

## Cache

Prepared images are stored in:

```text
~/Library/Caches/CommandV/ClipboardImages
```

The helper keeps the current prepared image and prunes older cached PNGs. This is needed because Finder pastes from a real file reference.

## Distribution Plan

The intended public distribution path is:

```bash
brew install command-v
```

Until the Homebrew formula exists, source install is the canonical path.

## License

MIT
