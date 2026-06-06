import Foundation

struct Song: Identifiable, Equatable, Hashable {
    let id: Int
    let title: String

    var numberedTitle: String {
        "(\(id)) \(title)"
    }
}
