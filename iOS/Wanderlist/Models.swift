import Foundation

struct Destination: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
    var notes: String = ""
    var visited: Bool = false
    var visitedDate: Date?
    var priority: Int = 1
    var createdAt: Date = Date()
}
