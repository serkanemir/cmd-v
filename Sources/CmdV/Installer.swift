import Foundation

struct Installer {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    var installURL: URL {
        preferredInstallDirectory.appendingPathComponent("cmd-v")
    }

    func installCurrentExecutable() throws -> URL {
        let source = try ExecutableLocator.currentExecutableURL()
        let destination = installURL

        try fileManager.createDirectory(
            at: destination.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        if source.standardizedFileURL.path != destination.standardizedFileURL.path {
            if fileManager.fileExists(atPath: destination.path) {
                try fileManager.removeItem(at: destination)
            }
            try fileManager.copyItem(at: source, to: destination)
        }

        try fileManager.setAttributes([.posixPermissions: 0o755], ofItemAtPath: destination.path)
        return destination
    }

    func removeInstalledBinaryIfPresent() throws {
        let destination = installURL
        if fileManager.fileExists(atPath: destination.path) {
            try fileManager.removeItem(at: destination)
        }
    }

    private var preferredInstallDirectory: URL {
        let pathDirectories = Set(
            (ProcessInfo.processInfo.environment["PATH"] ?? "")
                .split(separator: ":")
                .map(String.init)
        )

        let candidates = [
            URL(fileURLWithPath: "/opt/homebrew/bin", isDirectory: true),
            URL(fileURLWithPath: "/usr/local/bin", isDirectory: true)
        ]

        if let writablePathDirectory = candidates.first(where: { directory in
            pathDirectories.contains(directory.path)
                && fileManager.fileExists(atPath: directory.path)
                && fileManager.isWritableFile(atPath: directory.path)
        }) {
            return writablePathDirectory
        }

        return fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent(".local/bin", isDirectory: true)
    }
}
