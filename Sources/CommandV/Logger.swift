import Foundation

struct Logger {
    func print(_ message: String) {
        FileHandle.standardOutput.writeLine(message)
    }

    func info(_ message: String) {
        FileHandle.standardError.writeLine("info: \(message)")
    }

    func warning(_ message: String) {
        FileHandle.standardError.writeLine("warning: \(message)")
    }

    func error(_ message: String) {
        FileHandle.standardError.writeLine("error: \(message)")
    }
}

private extension FileHandle {
    func writeLine(_ message: String) {
        if let data = (message + "\n").data(using: .utf8) {
            write(data)
        }
    }
}
