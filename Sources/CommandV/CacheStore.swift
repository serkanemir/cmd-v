import Foundation

struct CacheStore {
    private let fileManager: FileManager
    let directory: URL
    let retention: TimeInterval
    let maximumFileCount: Int

    init(
        directory: URL? = nil,
        retention: TimeInterval = 24 * 60 * 60,
        maximumFileCount: Int = 25,
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        self.directory = directory ?? fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Caches/CommandV/ClipboardImages", isDirectory: true)
        self.retention = retention
        self.maximumFileCount = maximumFileCount
    }

    func writePNG(_ data: Data, date: Date = Date()) throws -> URL {
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)

        let baseName = FilenameGenerator.fileName(for: date)
        var destination = directory.appendingPathComponent(baseName)
        var counter = 2

        while fileManager.fileExists(atPath: destination.path) {
            destination = directory.appendingPathComponent(
                FilenameGenerator.fileName(for: date, suffix: counter)
            )
            counter += 1
        }

        try data.write(to: destination, options: .atomic)
        return destination
    }

    func prune(keeping currentFile: URL? = nil, now: Date = Date()) throws {
        guard fileManager.fileExists(atPath: directory.path) else {
            return
        }

        let files = try fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        )
        .filter { $0.pathExtension.lowercased() == "png" }

        let currentPath = currentFile?.standardizedFileURL.path
        let expired = files.filter { file in
            guard file.standardizedFileURL.path != currentPath else {
                return false
            }

            let modified = (try? file.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            return now.timeIntervalSince(modified) > retention
        }

        for file in expired {
            try? fileManager.removeItem(at: file)
        }

        let remaining = try fileManager.contentsOfDirectory(
            at: directory,
            includingPropertiesForKeys: [.contentModificationDateKey],
            options: [.skipsHiddenFiles]
        )
        .filter { $0.pathExtension.lowercased() == "png" && $0.standardizedFileURL.path != currentPath }
        .sorted { lhs, rhs in
            let lhsDate = (try? lhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            let rhsDate = (try? rhs.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            return lhsDate < rhsDate
        }

        let overflow = max(0, remaining.count - max(0, maximumFileCount - 1))
        for file in remaining.prefix(overflow) {
            try? fileManager.removeItem(at: file)
        }
    }
}
