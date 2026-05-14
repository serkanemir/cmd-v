import Foundation

struct Installer {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    var installURL: URL {
        fileManager
            .homeDirectoryForCurrentUser
            .appendingPathComponent(".local/bin/command-v")
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
}
