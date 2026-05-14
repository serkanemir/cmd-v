import Foundation
import Testing
@testable import CmdV

@Test func cacheWritesPNGFiles() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: directory) }

    let store = CacheStore(directory: directory)
    let url = try store.writePNG(Data([0x89, 0x50, 0x4E, 0x47]))

    #expect(FileManager.default.fileExists(atPath: url.path))
    #expect(url.pathExtension == "png")
}

@Test func cacheUsesPrivatePermissions() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: directory) }

    let store = CacheStore(directory: directory)
    let url = try store.writePNG(Data([0x89, 0x50, 0x4E, 0x47]))

    let directoryPermissions = try FileManager.default
        .attributesOfItem(atPath: directory.path)[.posixPermissions] as? NSNumber
    let filePermissions = try FileManager.default
        .attributesOfItem(atPath: url.path)[.posixPermissions] as? NSNumber

    #expect(directoryPermissions?.intValue == 0o700)
    #expect(filePermissions?.intValue == 0o600)
}

@Test func cacheHardensExistingPNGPermissions() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: directory) }

    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    let existing = directory.appendingPathComponent("existing.png")
    try Data([1]).write(to: existing)
    try FileManager.default.setAttributes([.posixPermissions: 0o644], ofItemAtPath: existing.path)

    let store = CacheStore(directory: directory)
    _ = try store.writePNG(Data([2]))

    let permissions = try FileManager.default
        .attributesOfItem(atPath: existing.path)[.posixPermissions] as? NSNumber

    #expect(permissions?.intValue == 0o600)
}

@Test func cachePruneKeepsCurrentFile() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: directory) }

    let store = CacheStore(directory: directory, retention: 0, maximumFileCount: 1)
    let old = try store.writePNG(Data([1]), date: Date(timeIntervalSince1970: 10))
    let current = try store.writePNG(Data([2]), date: Date(timeIntervalSince1970: 20))

    try store.prune(keeping: current, now: Date(timeIntervalSince1970: 30))

    #expect(!FileManager.default.fileExists(atPath: old.path))
    #expect(FileManager.default.fileExists(atPath: current.path))
}

@Test func cacheRemoveOnlyRemovesFilesInsideCacheDirectory() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    let outsideDirectory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer {
        try? FileManager.default.removeItem(at: directory)
        try? FileManager.default.removeItem(at: outsideDirectory)
    }

    let store = CacheStore(directory: directory)
    let inside = try store.writePNG(Data([1]))

    try FileManager.default.createDirectory(at: outsideDirectory, withIntermediateDirectories: true)
    let outside = outsideDirectory.appendingPathComponent("outside.png")
    try Data([2]).write(to: outside)

    try store.remove(outside)
    try store.remove(inside)

    #expect(FileManager.default.fileExists(atPath: outside.path))
    #expect(!FileManager.default.fileExists(atPath: inside.path))
}
