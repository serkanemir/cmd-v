import Foundation

enum ProcessRunner {
    @discardableResult
    static func run(executable: String, arguments: [String]) throws -> String {
        let output = try capture(executable: executable, arguments: arguments)
        return output
    }

    static func capture(executable: String, arguments: [String]) throws -> String {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: executable)
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        try process.run()
        process.waitUntilExit()

        let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8) ?? ""

        guard process.terminationStatus == 0 else {
            throw CommandVError.processFailed(
                executable: executable,
                arguments: arguments,
                status: process.terminationStatus,
                output: output
            )
        }

        return output
    }
}
