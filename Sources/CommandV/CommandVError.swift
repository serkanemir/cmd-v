import Foundation

enum CommandVError: LocalizedError {
    case invalidCommand(String)
    case noImageOnPasteboard
    case imageConversionFailed
    case pasteboardWriteFailed
    case executableNotFound
    case processFailed(executable: String, arguments: [String], status: Int32, output: String)

    var errorDescription: String? {
        switch self {
        case .invalidCommand(let command):
            "Unknown command: \(command). Run command-v help."
        case .noImageOnPasteboard:
            "No clipboard image found."
        case .imageConversionFailed:
            "Could not convert the clipboard image to PNG."
        case .pasteboardWriteFailed:
            "Could not write the Finder-compatible file reference back to the clipboard."
        case .executableNotFound:
            "Could not locate the current command-v executable."
        case .processFailed(let executable, let arguments, let status, let output):
            "\(executable) \(arguments.joined(separator: " ")) failed with status \(status).\n\(output)"
        }
    }
}
