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
        let observedChangeCount = pasteboard.changeCount

        if !force, observedChangeCount == lastObservedChangeCount {
            return .skipped("Clipboard has not changed.")
        }

        if PasteboardInspector.containsFileReference(in: pasteboard) {
            lastObservedChangeCount = observedChangeCount
            return .skipped("Clipboard already contains a file reference.")
        }

        guard let image = ImageCandidate.first(in: pasteboard) else {
            lastObservedChangeCount = observedChangeCount
            return .skipped("Clipboard does not contain an image.")
        }

        let pngData: Data
        do {
            pngData = try image.pngData()
            try ImageSizePolicy.validate(pngData)
        } catch {
            lastObservedChangeCount = observedChangeCount
            throw error
        }

        let fileURL: URL
        do {
            fileURL = try cacheStore.writePNG(pngData)
        } catch {
            lastObservedChangeCount = observedChangeCount
            throw error
        }

        guard pasteboard.changeCount == observedChangeCount else {
            try? cacheStore.remove(fileURL)
            lastObservedChangeCount = pasteboard.changeCount
            return .skipped("Clipboard changed during conversion.")
        }

        let payload = PasteboardPayload(pngData: pngData, fileURL: fileURL)

        pasteboard.clearContents()

        guard pasteboard.writeObjects(payload.objects) else {
            throw CmdVError.pasteboardWriteFailed
        }

        lastObservedChangeCount = pasteboard.changeCount
        try cacheStore.prune(keeping: fileURL)

        return .converted(fileURL)
    }
}

enum ImageSizePolicy {
    static let maximumPNGBytes = 100 * 1024 * 1024

    static func validate(_ data: Data) throws {
        guard data.count <= maximumPNGBytes else {
            throw CmdVError.imageTooLarge(bytes: data.count, maximumBytes: maximumPNGBytes)
        }
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
