import Foundation

struct Installer {
    private let fileManager: FileManager
    private let homeDirectory: URL

    init(
        fileManager: FileManager = .default,
        homeDirectory: URL? = nil
    ) {
        self.fileManager = fileManager
        self.homeDirectory = homeDirectory ?? fileManager.homeDirectoryForCurrentUser
    }

    var installURL: URL {
        installDirectory.appendingPathComponent("cmd-v")
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

    @discardableResult
    func removeInstalledBinaryIfPresent() throws -> Bool {
        let destination = installURL
        if fileManager.fileExists(atPath: destination.path) {
            try fileManager.removeItem(at: destination)
            return true
        }
        return false
    }

    private var installDirectory: URL {
        homeDirectory
            .appendingPathComponent(".local/bin", isDirectory: true)
    }
}
