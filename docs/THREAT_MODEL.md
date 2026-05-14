# Threat Model

cmd-v is a clipboard helper. The main risk is surprising the user by storing or forwarding more clipboard data than needed.

## Protected Data

- Clipboard image contents
- Generated PNG cache files
- Pasteboard metadata supplied by source apps

## Non-Goals

cmd-v does not try to protect against malware already running as the same macOS user. Such software can usually read the clipboard and user cache directories directly.

## Controls

- No network access in the product code
- No telemetry or analytics
- No clipboard history database
- No Accessibility permission
- No global keyboard/event hook
- No Finder automation
- Normalizes pasteboard output to image data plus generated file reference
- Drops unrelated source metadata such as HTML, source URLs, and app-private pasteboard types
- Stores generated PNGs in a private user cache directory
- Sets cache directory permissions to `0700`
- Sets generated PNG file permissions to `0600`
- Rejects generated PNG payloads above 100 MB
- Checks pasteboard change count before rewriting the clipboard
- Removes generated cache files if the clipboard changes during conversion
- Prunes old generated PNGs

## Residual Risks

- Clipboard images are materialized to disk so Finder can paste them as files.
- Other apps may observe the rewritten pasteboard after cmd-v prepares it.
- Very sensitive screenshots should be treated like any other local file once pasted into Finder.

## Public Release Requirements

- Keep the repository dependency-free unless a new dependency is clearly justified.
- Review all pasteboard types before adding support for new formats.
- Keep GitHub vulnerability reporting enabled for sensitive reports.
- Prefer signed and notarized binaries for non-technical users.
