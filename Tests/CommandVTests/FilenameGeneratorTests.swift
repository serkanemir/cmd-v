import Foundation
import Testing
@testable import CommandV

@Test func filenameIsFinderSafeAndStable() throws {
    let date = Date(timeIntervalSince1970: 1_715_702_400)
    let name = FilenameGenerator.fileName(for: date)

    #expect(name.hasPrefix("Command V "))
    #expect(name.hasSuffix(".png"))
    #expect(!name.contains(":"))
}

@Test func filenameSuffixIsAppendedBeforeExtension() throws {
    let date = Date(timeIntervalSince1970: 1_715_702_400)
    let name = FilenameGenerator.fileName(for: date, suffix: 2)

    #expect(name.hasSuffix(" 2.png"))
}
