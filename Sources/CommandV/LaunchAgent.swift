import Darwin
import Foundation

struct LaunchAgent {
    static let label = "dev.commandv.service"

    let binaryURL: URL

    static var plistURL: URL {
        FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/LaunchAgents/\(label).plist")
    }

    static var logDirectory: URL {
        FileManager.default
            .homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Logs/CommandV", isDirectory: true)
    }

    func install() throws {
        try FileManager.default.createDirectory(
            at: Self.plistURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try FileManager.default.createDirectory(at: Self.logDirectory, withIntermediateDirectories: true)

        let plist: [String: Any] = [
            "Label": Self.label,
            "ProgramArguments": [binaryURL.path, "run"],
            "RunAtLoad": true,
            "KeepAlive": true,
            "StandardOutPath": Self.logDirectory.appendingPathComponent("command-v.out.log").path,
            "StandardErrorPath": Self.logDirectory.appendingPathComponent("command-v.err.log").path,
            "EnvironmentVariables": [
                "COMMAND_V_LAUNCH_AGENT": "1"
            ]
        ]

        let data = try PropertyListSerialization.data(
            fromPropertyList: plist,
            format: .xml,
            options: 0
        )
        try data.write(to: Self.plistURL, options: .atomic)

        try? Self.stop()
        try Self.start()
    }

    static func uninstall() throws {
        try? stop()
        if FileManager.default.fileExists(atPath: plistURL.path) {
            try FileManager.default.removeItem(at: plistURL)
        }
    }

    static func start() throws {
        try? bootstrap()
        try ProcessRunner.run(
            executable: "/bin/launchctl",
            arguments: ["kickstart", "-k", serviceTarget]
        )
    }

    static func stop() throws {
        try ProcessRunner.run(
            executable: "/bin/launchctl",
            arguments: ["bootout", serviceTarget]
        )
    }

    static func restart() throws {
        try? stop()
        try start()
    }

    static func status() throws {
        let output = try ProcessRunner.capture(
            executable: "/bin/launchctl",
            arguments: ["print", serviceTarget]
        )
        FileHandle.standardOutput.write(output.data(using: .utf8) ?? Data())
    }

    private static func bootstrap() throws {
        try ProcessRunner.run(
            executable: "/bin/launchctl",
            arguments: ["bootstrap", guiTarget, plistURL.path]
        )
    }

    private static var uid: uid_t {
        getuid()
    }

    private static var guiTarget: String {
        "gui/\(uid)"
    }

    private static var serviceTarget: String {
        "\(guiTarget)/\(label)"
    }
}
