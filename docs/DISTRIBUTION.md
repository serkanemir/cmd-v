# Distribution

cmd-v is designed for GitHub and Homebrew distribution, not the Mac App Store.

## Phase 1: Source Install

Users can install from a cloned repo:

```bash
git clone https://github.com/serkanemir/cmd-v.git
cd cmd-v
./scripts/install.sh
```

This builds a release binary, copies it to the first writable standard bin directory in `PATH`, and registers a per-user LaunchAgent.

## Phase 2: Homebrew Tap

Create a tap repository, for example:

```text
github.com/serkanemir/homebrew-tap
```

Then add a formula so users can install with:

```bash
brew tap serkanemir/tap
brew install cmd-v
```

The draft formula lives at:

```text
packaging/homebrew/cmd-v.rb
```

Once the project has enough usage, submit it to Homebrew core if it fits their acceptance rules.

## Phase 3: Signed Binary

For non-technical users, attach a signed and notarized zip or pkg to GitHub Releases.

This does not require the Mac App Store, but it does require an Apple Developer ID certificate. Without signing and notarization, macOS Gatekeeper may show warnings for downloaded binaries.

## Release Checklist

1. Update `Version.current`.
2. Run `swift test`.
3. Build release with `swift build -c release`.
4. Tag the release.
5. Upload source archive and optional notarized binary.
6. Update the Homebrew formula checksum.

See `docs/PUBLIC_RELEASE_CHECKLIST.md` before making the repository public.
