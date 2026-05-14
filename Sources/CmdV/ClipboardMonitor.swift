import Foundation

final class ClipboardMonitor {
    private let converter: ClipboardConverter
    private let logger: Logger
    private let pollInterval: TimeInterval

    init(
        converter: ClipboardConverter = ClipboardConverter(),
        logger: Logger,
        pollInterval: TimeInterval = 0.65
    ) {
        self.converter = converter
        self.logger = logger
        self.pollInterval = pollInterval
    }

    func run() throws {
        logger.info("cmd-v is running. Press Ctrl+C to stop.")

        while true {
            do {
                let outcome = try converter.convertCurrentPasteboard()
                if case .converted(let url) = outcome {
                    logger.info("Prepared Finder paste for \(url.lastPathComponent)")
                }
            } catch {
                logger.warning(error.localizedDescription)
            }

            Thread.sleep(forTimeInterval: pollInterval)
        }
    }
}
