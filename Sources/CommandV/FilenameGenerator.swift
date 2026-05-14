import Foundation

enum FilenameGenerator {
    static func fileName(for date: Date, suffix: Int? = nil) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd 'at' HH.mm.ss"

        let suffixText = suffix.map { " \($0)" } ?? ""
        return "cmd-v \(formatter.string(from: date))\(suffixText).png"
    }
}
