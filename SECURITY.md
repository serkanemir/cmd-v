# Security

cmd-v touches clipboard data, so the project keeps a deliberately small security surface.

Maintainer: [Serkan Emir](https://github.com/serkanemir)

## Supported Versions

cmd-v is public alpha software.

| Version | Security support |
| --- | --- |
| 0.1.x | Yes |
| < 0.1.0 | No |

## Local-Only Design

- No network code
- No telemetry
- No account system
- No clipboard history database
- No Accessibility permission
- No keyboard event tap
- No Finder automation

The helper only watches `NSPasteboard.general.changeCount`. When the current clipboard contains image data and does not already contain a file reference, it writes a temporary PNG and appends that file reference to the pasteboard.

cmd-v does not preserve arbitrary pasteboard types. It intentionally normalizes the clipboard down to image data plus the generated file reference, so copied source URLs, HTML fragments, and app-private pasteboard metadata are not carried forward.

## Cached Images

Generated PNG files are stored in:

```text
~/Library/Caches/cmd-v/ClipboardImages
```

The cache exists so Finder can paste a real file. Old files are pruned automatically, and cmd-v keeps only a small number of recent generated images.

Cache permissions:

- Directory: `0700`
- Generated PNG files: `0600`

cmd-v rejects generated PNG payloads above 100 MB.

## Reporting Issues

For sensitive security reports, use GitHub's private vulnerability reporting flow for this repository when available. If that is unavailable, open a minimal public issue that says a security report is available without posting exploit details.

For non-sensitive issues, open a normal GitHub issue.
