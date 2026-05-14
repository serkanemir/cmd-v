import Darwin
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
        let stopFlag = StopFlag()
        let signalQueue = DispatchQueue(label: "io.github.serkanemir.cmdv.signals")
        let signalSources = [
            makeSignalSource(SIGTERM, queue: signalQueue, stopFlag: stopFlag),
            makeSignalSource(SIGINT, queue: signalQueue, stopFlag: stopFlag)
        ]
        signalSources.forEach { $0.resume() }
        defer {
            signalSources.forEach { $0.cancel() }
            signal(SIGTERM, SIG_DFL)
            signal(SIGINT, SIG_DFL)
        }

        while !stopFlag.isStopped {
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

        logger.info("cmd-v stopped.")
    }

    private func makeSignalSource(
        _ signalNumber: Int32,
        queue: DispatchQueue,
        stopFlag: StopFlag
    ) -> DispatchSourceSignal {
        signal(signalNumber, SIG_IGN)

        let source = DispatchSource.makeSignalSource(signal: signalNumber, queue: queue)
        source.setEventHandler {
            stopFlag.stop()
        }
        return source
    }
}

private final class StopFlag {
    private let lock = NSLock()
    private var stopped = false

    var isStopped: Bool {
        lock.lock()
        defer { lock.unlock() }
        return stopped
    }

    func stop() {
        lock.lock()
        stopped = true
        lock.unlock()
    }
}
