import AppKit

enum PasteboardInspector {
    private static let fileReferenceTypes: Set<String> = [
        NSPasteboard.PasteboardType.fileURL.rawValue,
        "public.file-url",
        "NSFilenamesPboardType"
    ]

    static func containsFileReference(in pasteboard: NSPasteboard) -> Bool {
        guard let items = pasteboard.pasteboardItems else {
            return pasteboard.types?.contains { fileReferenceTypes.contains($0.rawValue) } ?? false
        }

        return items.contains { item in
            item.types.contains { fileReferenceTypes.contains($0.rawValue) }
        }
    }
}
