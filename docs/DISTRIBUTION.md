# Distribution

cmd-v is designed for GitHub and Homebrew distribution, not the Mac App Store.

## Phase 1: Source Install

Users can install from a cloned repo:

```bash
git clone https://github.com/serkanemir/cmd-v.git
cd cmd-v
./scripts/install.sh
```

This builds a release binary, copies it to `~/.local/bin/cmd-v`, and registers a per-user LaunchAgent. Source installs do not write into Homebrew-owned directories.

Current source-build requirements:

- macOS 12 Monterey deployment target
- Swift 6 / Xcode 16 or newer to build from source

## Homebrew Tap

The tap repository is:

```text
github.com/serkanemir/homebrew-tap
```

Users can install with:

```bash
brew tap serkanemir/tap
brew install cmd-v
brew services start cmd-v
```

The live formula is maintained in the tap repository:

```text
github.com/serkanemir/homebrew-tap/Formula/cmd-v.rb
```

Once the project has enough usage, submit it to Homebrew core if it fits their acceptance rules.

## Phase 3: Signed Binary for v0.2.0

For non-technical users, attach a signed and notarized zip or pkg to GitHub Releases.

This does not require the Mac App Store, but it does require an Apple Developer ID certificate. Without signing and notarization, macOS Gatekeeper may show warnings for downloaded binaries.

Target: revisit signed and notarized release artifacts for `v0.2.0`.

## Release Checklist

1. Update `Version.current`.
2. Run `swift test`.
3. Build release with `swift build -c release`.
4. Confirm the built binary reports `minos 12.0` with `otool -l`.
5. Tag the release.
6. Upload source archive and optional notarized binary.
7. Update the Homebrew tap formula URL and checksum.

See `docs/PUBLIC_RELEASE_CHECKLIST.md` before publishing a release.
