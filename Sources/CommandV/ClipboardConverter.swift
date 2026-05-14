import AppKit
import Foundation

final class ClipboardConverter {
    private let pasteboard: NSPasteboard
    private let cacheStore: CacheStore
    private var lastObservedChangeCount: Int

    init(
        pasteboard: NSPasteboard = .general,
        cacheStore: CacheStore = CacheStore()
    ) {
        self.pasteboard = pasteboard
        self.cacheStore = cacheStore
        self.lastObservedChangeCount = pasteboard.changeCount
    }

    func convertCurrentPasteboard(force: Bool = false) throws -> ConversionOutcome {
        if !force, pasteboard.changeCount == lastObservedChangeCount {
            return .skipped("Clipboard has not changed.")
        }

        if PasteboardInspector.containsFileReference(in: pasteboard) {
            lastObservedChangeCount = pasteboard.changeCount
            return .skipped("Clipboard already contains a file reference.")
        }

        guard let image = ImageCandidate.first(in: pasteboard) else {
            lastObservedChangeCount = pasteboard.changeCount
            return .skipped("Clipboard does not contain an image.")
        }

        let pngData = try image.pngData()
        let fileURL = try cacheStore.writePNG(pngData)
        let snapshot = PasteboardSnapshot.capture(from: pasteboard)

        guard !snapshot.items.isEmpty else {
            throw CommandVError.noImageOnPasteboard
        }

        pasteboard.clearContents()
        var objects: [NSPasteboardWriting] = snapshot.items
        objects.append(fileURL as NSURL)

        guard pasteboard.writeObjects(objects) else {
            throw CommandVError.pasteboardWriteFailed
        }

        lastObservedChangeCount = pasteboard.changeCount
        try cacheStore.prune(keeping: fileURL)

        return .converted(fileURL)
    }
}

enum ConversionOutcome {
    case converted(URL)
    case skipped(String)

    var userFacingMessage: String {
        switch self {
        case .converted(let url):
            "Prepared Finder paste: \(url.path)"
        case .skipped(let reason):
            "Skipped: \(reason)"
        }
    }
}
