import Foundation
import Testing
@testable import CmdV

@Test func installerUsesHomeLocalBin() throws {
    let home = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: home) }

    let installer = Installer(homeDirectory: home)

    #expect(installer.installURL.path == home.appendingPathComponent(".local/bin/cmd-v").path)
}

@Test func installerRemovalOnlyTouchesSourceInstallPath() throws {
    let home = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: home) }

    let installer = Installer(homeDirectory: home)
    try FileManager.default.createDirectory(
        at: installer.installURL.deletingLastPathComponent(),
        withIntermediateDirectories: true
    )
    try Data([1]).write(to: installer.installURL)

    let homebrewLikeDirectory = home.appendingPathComponent("opt/homebrew/bin", isDirectory: true)
    try FileManager.default.createDirectory(at: homebrewLikeDirectory, withIntermediateDirectories: true)
    let homebrewLikeBinary = homebrewLikeDirectory.appendingPathComponent("cmd-v")
    try Data([2]).write(to: homebrewLikeBinary)

    let removed = try installer.removeInstalledBinaryIfPresent()

    #expect(removed)
    #expect(!FileManager.default.fileExists(atPath: installer.installURL.path))
    #expect(FileManager.default.fileExists(atPath: homebrewLikeBinary.path))
}

