import Darwin
import Foundation

struct CommandLineInterface {
    let arguments: [String]
    private let logger = Logger()

    func run() {
        do {
            try execute()
        } catch {
            logger.error(error.localizedDescription)
            exit(1)
        }
    }

    private func execute() throws {
        let command = arguments.first ?? "help"

        switch command {
        case "run":
            try ClipboardMonitor(logger: logger).run()
        case "convert", "once":
            let outcome = try ClipboardConverter().convertCurrentPasteboard(force: true)
            logger.print(outcome.userFacingMessage)
        case "install":
            let installedBinary = try Installer().installCurrentExecutable()
            try LaunchAgent(binaryURL: installedBinary).install()
            logger.print("Command V installed and started.")
            logger.print("Binary: \(installedBinary.path)")
        case "uninstall":
            try LaunchAgent.uninstall()
            try Installer().removeInstalledBinaryIfPresent()
            logger.print("Command V stopped and uninstalled.")
        case "start":
            try LaunchAgent.start()
            logger.print("Command V started.")
        case "stop":
            try LaunchAgent.stop()
            logger.print("Command V stopped.")
        case "restart":
            try LaunchAgent.restart()
            logger.print("Command V restarted.")
        case "status":
            try LaunchAgent.status()
        case "doctor":
            try Doctor(logger: logger).run()
        case "--version", "version":
            logger.print(Version.current)
        case "-h", "--help", "help":
            logger.print(Self.helpText)
        default:
            throw CommandVError.invalidCommand(command)
        }
    }

    static let helpText = """
    Command V \(Version.current)

    Paste clipboard images into Finder as files with Cmd+V.

    Usage:
      command-v run         Run the clipboard helper in the foreground
      command-v convert     Convert the current clipboard image once
      command-v install     Install the helper for the current user and start it
      command-v uninstall   Stop and remove the helper
      command-v start       Start the LaunchAgent
      command-v stop        Stop the LaunchAgent
      command-v restart     Restart the LaunchAgent
      command-v status      Print LaunchAgent status
      command-v doctor      Print local diagnostics
      command-v version     Print version
    """
}
