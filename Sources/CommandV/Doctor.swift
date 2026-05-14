import AppKit
import Foundation

struct Doctor {
    let logger: Logger

    func run() throws {
        logger.print("Command V \(Version.current)")
        logger.print("Executable: \((try? ExecutableLocator.currentExecutableURL().path) ?? "unknown")")
        logger.print("Install path: \(Installer().installURL.path)")
        logger.print("LaunchAgent: \(LaunchAgent.plistURL.path)")
        logger.print("Cache: \(CacheStore().directory.path)")
        logger.print("Pasteboard change count: \(NSPasteboard.general.changeCount)")

        if PasteboardInspector.containsFileReference(in: .general) {
            logger.print("Clipboard: file reference present")
        } else if ImageCandidate.first(in: .general) != nil {
            logger.print("Clipboard: image present")
        } else {
            logger.print("Clipboard: no image")
        }
    }
}
