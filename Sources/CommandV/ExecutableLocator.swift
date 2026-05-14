import Foundation

enum ExecutableLocator {
    static func currentExecutableURL() throws -> URL {
        if let bundleURL = Bundle.main.executableURL {
            return bundleURL.resolvingSymlinksInPath()
        }

        guard let firstArgument = CommandLine.arguments.first, !firstArgument.isEmpty else {
            throw CommandVError.executableNotFound
        }

        let url: URL
        if firstArgument.hasPrefix("/") {
            url = URL(fileURLWithPath: firstArgument)
        } else {
            url = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent(firstArgument)
        }

        return url.resolvingSymlinksInPath()
    }
}
