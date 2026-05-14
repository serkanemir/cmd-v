import Foundation

enum CmdVError: LocalizedError {
    case invalidCommand(String)
    case noImageOnPasteboard
    case imageConversionFailed
    case imageTooLarge(bytes: Int, maximumBytes: Int)
    case pasteboardWriteFailed
    case executableNotFound
    case processFailed(executable: String, arguments: [String], status: Int32, output: String)

    var errorDescription: String? {
        switch self {
        case .invalidCommand(let command):
            "Unknown command: \(command). Run cmd-v help."
        case .noImageOnPasteboard:
            "No clipboard image found."
        case .imageConversionFailed:
            "Could not convert the clipboard image to PNG."
        case .imageTooLarge(let bytes, let maximumBytes):
            "Clipboard image is too large to cache safely (\(bytes) bytes, limit \(maximumBytes) bytes)."
        case .pasteboardWriteFailed:
            "Could not write the Finder-compatible file reference back to the clipboard."
        case .executableNotFound:
            "Could not locate the current cmd-v executable."
        case .processFailed(let executable, let arguments, let status, let output):
            "\(executable) \(arguments.joined(separator: " ")) failed with status \(status).\n\(output)"
        }
    }
}
