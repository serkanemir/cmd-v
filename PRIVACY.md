# Privacy

cmd-v runs locally on your Mac.

It does not:

- Send data over the network
- Collect analytics
- Keep clipboard history
- Create accounts
- Use cloud sync
- Read your files outside its generated cache files

When the clipboard contains an image, cmd-v writes a generated PNG to:

```text
~/Library/Caches/cmd-v/ClipboardImages
```

That file exists so Finder can paste it with `Cmd+V`. Old generated files are pruned automatically.
