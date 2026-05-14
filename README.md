# cmd-v

Paste clipboard images into Finder as files with `Cmd+V`.

cmd-v is a tiny native macOS helper. When your clipboard contains an image, it prepares a private temporary PNG file reference alongside safe image data. Finder can then use its normal `Cmd+V` behavior to paste that image into the current folder as a file.

Maintainer: [Serkan Emir](https://github.com/serkanemir)

Status: public alpha.

## Why

macOS can copy screenshots directly to the clipboard, but Finder does not paste raw image clipboard data as a new file. cmd-v fills only that gap.

## Install

For now, build and install from source:

```bash
git clone https://github.com/serkanemir/cmd-v.git
cd cmd-v
./scripts/install.sh
```

This installs `cmd-v` to the first writable standard bin directory in your `PATH`, usually `/opt/homebrew/bin/cmd-v` on Apple Silicon Macs. If no standard bin directory is writable, it falls back to `~/.local/bin/cmd-v`. It also starts a per-user LaunchAgent.

## Use

1. Take a screenshot to the clipboard, for example `Ctrl+Cmd+Shift+4`.
2. Open Finder.
3. Press `Cmd+V`.

The pasted file is created from a cached PNG representation of the clipboard image.

This flow has been tested with a local Finder folder and `Cmd+V`.

## Commands

```bash
cmd-v status
cmd-v stop
cmd-v start
cmd-v restart
cmd-v doctor
cmd-v uninstall
```

For development:

```bash
swift run cmd-v run
swift run cmd-v convert
swift test
```

## Privacy

cmd-v is intentionally narrow:

- No clipboard history
- No telemetry
- No network calls
- No accounts
- No cloud sync
- No App Store dependency
- No keyboard hook
- No Accessibility permission
- No Finder automation

It watches the pasteboard change count locally and only acts when the current clipboard contains image data and no existing file reference.

To avoid copying unrelated clipboard metadata, cmd-v rewrites the pasteboard with a normalized image item and the generated file reference. It does not preserve source HTML, source URLs, or arbitrary app-private pasteboard types.

See also:

- `PRIVACY.md`
- `SECURITY.md`
- `docs/THREAT_MODEL.md`
- `docs/SECURITY_REVIEW.md`

## Cache

Prepared images are stored in:

```text
~/Library/Caches/cmd-v/ClipboardImages
```

The helper keeps the current prepared image and prunes older cached PNGs. This is needed because Finder pastes from a real file reference.

Cache permissions are locked down:

- Directory: `0700`
- Generated PNG files: `0600`

Images larger than 100 MB are rejected instead of being written to disk.

## Uninstall

```bash
cmd-v uninstall
```

or from the repo:

```bash
./scripts/uninstall.sh
```

## Distribution Plan

The intended public distribution path is:

```bash
brew install cmd-v
```

Until the Homebrew formula exists, source install is the canonical path.

## License

MIT
