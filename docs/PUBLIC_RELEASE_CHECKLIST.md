# Public Release Checklist

Before making the repository public:

1. Confirm the product name and repo name.
2. Review `README.md`, `PRIVACY.md`, `SECURITY.md`, and `docs/THREAT_MODEL.md`.
3. Review `docs/SECURITY_REVIEW.md`.
4. Enable GitHub private vulnerability reporting.
5. Confirm no local test screenshots or generated files are tracked.
6. Run `swift test`.
7. Run `./scripts/install.sh`.
8. Test `Ctrl+Cmd+Shift+4` screenshot to clipboard, then Finder `Cmd+V`.
9. Test copied web image to Finder `Cmd+V`.
10. Test copying an existing file in Finder remains unchanged.
11. Tag `v0.1.0`.
12. Create a GitHub release.
13. Update the Homebrew formula checksum.
14. Decide whether to sign and notarize a binary release.
