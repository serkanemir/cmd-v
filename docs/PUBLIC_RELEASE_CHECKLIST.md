# Public Release Checklist

Before making the repository public:

1. Confirm the product name and repo name.
2. Review `README.md`, `PRIVACY.md`, `SECURITY.md`, and `docs/THREAT_MODEL.md`.
3. Enable GitHub private vulnerability reporting.
4. Confirm no local test screenshots or generated files are tracked.
5. Run `swift test`.
6. Run `./scripts/install.sh`.
7. Test `Ctrl+Cmd+Shift+4` screenshot to clipboard, then Finder `Cmd+V`.
8. Test copied web image to Finder `Cmd+V`.
9. Test copying an existing file in Finder remains unchanged.
10. Tag `v0.1.0`.
11. Create a GitHub release.
12. Update the Homebrew formula checksum.
13. Decide whether to sign and notarize a binary release.
