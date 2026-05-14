# Changelog

All notable changes to this project are documented in this file.

## [Unreleased]

## [0.1.1] - 2026-05-14

### Changed

- Install source builds to `~/.local/bin/cmd-v` instead of Homebrew-owned directories.
- Document verified macOS versions more precisely.
- Treat Homebrew as the source of truth for Homebrew formula distribution.

### Added

- Add community issue and pull request templates.
- Add supported versions to the security policy.
- Add graceful `SIGTERM` and `SIGINT` shutdown for the clipboard monitor.
- Add release and installer coverage checks.

## [0.1.0] - 2026-05-14

- Initial public alpha.
- Convert clipboard images into Finder-pasteable file references.
- Install and run as a per-user LaunchAgent.
- Add local-only privacy and security posture.
- Normalize pasteboard output to image data plus generated file reference.
- Store generated PNGs with private file permissions.
- Add tests for cache permissions, payload shape, filename generation, and size limits.

[Unreleased]: https://github.com/serkanemir/cmd-v/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/serkanemir/cmd-v/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/serkanemir/cmd-v/releases/tag/v0.1.0
