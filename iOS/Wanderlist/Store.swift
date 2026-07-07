import Foundation
import Combine

final class WanderlistStore: ObservableObject {
    static let freeTierLimit = 20

    @Published var destinations: [Destination] = [] { didSet { persist() } }

    private let fileURL: URL

    init() {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: support, withIntermediateDirectories: true)
        fileURL = support.appendingPathComponent("wanderliststore.json")
        load()
    }

    var isAtFreeLimit: Bool { destinations.count >= Self.freeTierLimit }

    func canAdd(isPro: Bool) -> Bool {
        isPro || destinations.count < Self.freeTierLimit
    }

    func add(_ entry: Destination, isPro: Bool) -> Bool {
        guard canAdd(isPro: isPro) else { return false }
        destinations.append(entry)
        return true
    }

    func remove(at offsets: IndexSet) {
        destinations.remove(atOffsets: offsets)
    }

    func update(_ entry: Destination) {
        if let idx = destinations.firstIndex(where: { $0.id == entry.id }) {
            destinations[idx] = entry
        }
    }

    private func seedIfNeeded() {
        if destinations.isEmpty {
            destinations = [Self.sampleSeed]
        }
    }

    private func persist() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(PersistedState(destinations: destinations)) {
            try? data.write(to: fileURL)
        }
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            seedIfNeeded()
            return
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let state = try? decoder.decode(PersistedState.self, from: data) {
            self.destinations = state.destinations
            
        }
        seedIfNeeded()
    }

    struct PersistedState: Codable {
        var destinations: [Destination]
        
    }
    static let sampleSeed = Destination(name: "Kyoto, Japan", notes: "Cherry blossoms in spring", visited: false, priority: 3)
}
