import AppKit
import Foundation

enum ImageCandidate {
    case png(Data)
    case encoded(Data)
    case image(NSImage)

    static func first(in pasteboard: NSPasteboard) -> ImageCandidate? {
        if let directPNG = firstData(for: [.png, NSPasteboard.PasteboardType("public.png")], in: pasteboard) {
            return .png(directPNG)
        }

        let convertibleTypes: [NSPasteboard.PasteboardType] = [
            .tiff,
            NSPasteboard.PasteboardType("public.tiff"),
            NSPasteboard.PasteboardType("public.jpeg"),
            NSPasteboard.PasteboardType("public.heic"),
            NSPasteboard.PasteboardType("com.compuserve.gif")
        ]

        if let encoded = firstData(for: convertibleTypes, in: pasteboard) {
            return .encoded(encoded)
        }

        if let image = NSImage(pasteboard: pasteboard) {
            return .image(image)
        }

        return nil
    }

    func pngData() throws -> Data {
        switch self {
        case .png(let data):
            return data
        case .encoded(let data):
            guard let image = NSImage(data: data), let png = image.pngRepresentation() else {
                throw CommandVError.imageConversionFailed
            }
            return png
        case .image(let image):
            guard let png = image.pngRepresentation() else {
                throw CommandVError.imageConversionFailed
            }
            return png
        }
    }

    private static func firstData(
        for types: [NSPasteboard.PasteboardType],
        in pasteboard: NSPasteboard
    ) -> Data? {
        guard let items = pasteboard.pasteboardItems else {
            for type in types {
                if let data = pasteboard.data(forType: type), !data.isEmpty {
                    return data
                }
            }
            return nil
        }

        for item in items {
            for type in types where item.types.contains(type) {
                if let data = item.data(forType: type), !data.isEmpty {
                    return data
                }
            }
        }

        return nil
    }
}

private extension NSImage {
    func pngRepresentation() -> Data? {
        guard
            let tiff = tiffRepresentation,
            let bitmap = NSBitmapImageRep(data: tiff)
        else {
            return nil
        }

        return bitmap.representation(using: .png, properties: [:])
    }
}
