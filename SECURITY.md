# Security

Command V touches clipboard data, so the project keeps a deliberately small security surface.

## Local-Only Design

- No network code
- No telemetry
- No account system
- No clipboard history database
- No Accessibility permission
- No keyboard event tap
- No Finder automation

The helper only watches `NSPasteboard.general.changeCount`. When the current clipboard contains image data and does not already contain a file reference, it writes a temporary PNG and appends that file reference to the pasteboard.

## Cached Images

Generated PNG files are stored in:

```text
~/Library/Caches/CommandV/ClipboardImages
```

The cache exists so Finder can paste a real file. Old files are pruned automatically, and Command V keeps only a small number of recent generated images.

## Reporting Issues

For now, open a private issue or contact the maintainer directly before publishing a security report. Once the public GitHub repo is created, this section should be updated with the maintainer email.
