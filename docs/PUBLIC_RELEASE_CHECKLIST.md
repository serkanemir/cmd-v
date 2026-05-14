# Release Checklist

Before each release:

1. Confirm the product name and repo name.
2. Review `README.md`, `PRIVACY.md`, `SECURITY.md`, and `docs/THREAT_MODEL.md`.
3. Review `docs/SECURITY_REVIEW.md`.
4. Confirm GitHub vulnerability reporting is available for sensitive reports.
5. Confirm no local test screenshots or generated files are tracked.
6. Run `swift test`.
7. Run `./scripts/install.sh`.
8. Confirm `otool -l $(command -v cmd-v)` reports `minos 12.0`.
9. Test `Ctrl+Cmd+Shift+4` screenshot to clipboard, then Finder `Cmd+V`.
10. Test copied web image to Finder `Cmd+V`.
11. Test copying an existing file in Finder remains unchanged.
12. Tag `v0.1.0`.
13. Create a GitHub release.
14. Update the Homebrew formula checksum.
15. Decide whether to sign and notarize a binary release.
