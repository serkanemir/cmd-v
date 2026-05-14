import Foundation
import Testing
@testable import CmdV

@Test func imageSizePolicyAllowsReasonableData() throws {
    try ImageSizePolicy.validate(Data(repeating: 1, count: 1024))
}

@Test func imageSizePolicyRejectsOversizedData() throws {
    let data = Data(repeating: 1, count: ImageSizePolicy.maximumPNGBytes + 1)

    #expect(throws: CmdVError.self) {
        try ImageSizePolicy.validate(data)
    }
}
