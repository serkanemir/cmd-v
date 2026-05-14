import AppKit

struct PasteboardSnapshot {
    let items: [NSPasteboardItem]

    static func capture(from pasteboard: NSPasteboard) -> PasteboardSnapshot {
        let copiedItems = pasteboard.pasteboardItems?.compactMap(copyItem) ?? []
        return PasteboardSnapshot(items: copiedItems)
    }

    private static func copyItem(_ original: NSPasteboardItem) -> NSPasteboardItem? {
        let copy = NSPasteboardItem()
        var wroteAtLeastOneType = false

        for type in original.types {
            if let data = original.data(forType: type), !data.isEmpty {
                copy.setData(data, forType: type)
                wroteAtLeastOneType = true
            } else if let string = original.string(forType: type), !string.isEmpty {
                copy.setString(string, forType: type)
                wroteAtLeastOneType = true
            }
        }

        return wroteAtLeastOneType ? copy : nil
    }
}
