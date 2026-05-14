# Security Review

Review date: 2026-05-14

This is an internal pre-public-release security review for `cmd-v`. It is not a third-party audit.

## Scope

Reviewed:

- Swift package configuration
- Clipboard conversion flow
- Pasteboard type handling
- Cache file storage
- LaunchAgent install/start/stop lifecycle
- Install and uninstall scripts
- README, privacy, security, threat model, and distribution docs

## Checks Performed

- Searched source and scripts for network APIs and URL/session usage.
- Searched source and scripts for Accessibility, keyboard hook, event tap, Finder automation, AppleScript, and System Events usage.
- Verified there are no third-party package dependencies.
- Verified generated cache files are written under the current user's cache directory.
- Verified cache directory permissions are set to `0700`.
- Verified generated PNG file permissions are set to `0600`.
- Verified old generated cache PNGs are hardened to `0600`.
- Verified clipboard output is normalized to image data plus a generated file reference.
- Verified source HTML, source URLs, and arbitrary app-private pasteboard types are not preserved.
- Verified existing file references are skipped instead of rewritten.
- Verified non-image clipboard contents are skipped.
- Verified a pasteboard change-count guard prevents rewriting newer clipboard contents after a race.
- Verified oversized generated PNG payloads above 100 MB are rejected.
- Verified the helper runs as a per-user LaunchAgent, not as root.
- Verified product code has no telemetry, analytics, account, cloud sync, or network behavior.

## Findings

No high-risk issues were found in the reviewed scope.

The highest-sensitivity behavior is expected for this product: clipboard images are materialized to disk so Finder can paste them as files. This behavior is documented in `README.md`, `PRIVACY.md`, `SECURITY.md`, and `docs/THREAT_MODEL.md`.

## Residual Risks

- This is not a formal external security audit.
- Any same-user process on macOS may be able to observe clipboard contents.
- Other apps may observe the normalized pasteboard after `cmd-v` prepares it.
- Generated PNG files exist on disk until pruned or pasted/copied elsewhere by the user.
- Image decoding relies on Apple's AppKit image stack.

## Public Release Recommendations

- Keep the project dependency-free unless a dependency is clearly justified.
- Keep the README, privacy, and release checklist current before each release.
- Keep GitHub vulnerability reporting enabled for sensitive reports.
- Prefer signed and notarized binaries for non-technical users.
- Consider a brief independent review after the first public release if the project gets meaningful adoption.
