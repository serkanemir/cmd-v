# Release Checklist

Before each release:

1. Confirm the product name and repo name.
2. Review `README.md`, `PRIVACY.md`, `SECURITY.md`, and `docs/THREAT_MODEL.md`.
3. Review `docs/SECURITY_REVIEW.md`.
4. Confirm GitHub vulnerability reporting is available for sensitive reports.
5. Confirm no local test screenshots or generated files are tracked.
6. Run `swift test`.
7. Run `swift build -c release`.
8. Run `./scripts/install.sh`.
9. Confirm the source install path is `~/.local/bin/cmd-v`.
10. Confirm `otool -l ~/.local/bin/cmd-v` reports `minos 12.0`.
11. Confirm Homebrew formula install and service start after the tap checksum is updated.
12. Test `Ctrl+Cmd+Shift+4` screenshot to clipboard, then Finder `Cmd+V`.
13. Test copied web image to Finder `Cmd+V`.
14. Test copying an existing file in Finder remains unchanged.
15. Tag the new release.
16. Create a GitHub release.
17. Update the Homebrew tap formula checksum.
18. Decide whether to sign and notarize a binary release.
