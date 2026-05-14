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
            let installer = Installer()
            let installedBinary = try installer.installCurrentExecutable()
            try LaunchAgent(binaryURL: installedBinary).install()
            logger.print("cmd-v installed and started.")
            logger.print("Binary: \(installedBinary.path)")
        case "uninstall":
            let installer = Installer()
            let removedAgent = try LaunchAgent.uninstall(expectedBinaryURL: installer.installURL)
            let removedBinary = try installer.removeInstalledBinaryIfPresent()

            if removedAgent || removedBinary {
                logger.print("cmd-v source install stopped and uninstalled.")
            } else {
                logger.print("No source cmd-v installation found at \(installer.installURL.path).")
                logger.print("If you installed with Homebrew, run: brew services stop cmd-v && brew uninstall cmd-v")
            }
        case "start":
            try LaunchAgent.start()
            logger.print("cmd-v started.")
        case "stop":
            try LaunchAgent.stop()
            logger.print("cmd-v stopped.")
        case "restart":
            try LaunchAgent.restart()
            logger.print("cmd-v restarted.")
        case "status":
            try LaunchAgent.status()
        case "doctor":
            try Doctor(logger: logger).run()
        case "--version", "version":
            logger.print(Version.current)
        case "-h", "--help", "help":
            logger.print(Self.helpText)
        default:
            throw CmdVError.invalidCommand(command)
        }
    }

    static let helpText = """
    cmd-v \(Version.current)

    Paste clipboard images into Finder as files with Cmd+V.

    Usage:
      cmd-v run         Run the clipboard helper in the foreground
      cmd-v convert     Convert the current clipboard image once
      cmd-v install     Install the helper for the current user and start it
      cmd-v uninstall   Stop and remove the helper
      cmd-v start       Start the LaunchAgent
      cmd-v stop        Stop the LaunchAgent
      cmd-v restart     Restart the LaunchAgent
      cmd-v status      Print LaunchAgent status
      cmd-v doctor      Print local diagnostics
      cmd-v version     Print version
    """
}
