import Foundation
import Testing
@testable import CommandV

@Test func cacheWritesPNGFiles() throws {
    let directory = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: directory) }

    let store = CacheStore(directory: directory)
    let url = try store.writePNG(Data([0x89, 0x50, 0x4E, 0x47]))

    #expect(FileManager.default.fileExists(atPath: url.path))
    #expect(url.pathExtension == "png")
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
