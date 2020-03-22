//
//  Created by Mateusz Matrejek
//

import Foundation

public struct PersistentStoreKey: RawRepresentable {

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public init?(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public var rawValue: String

    public typealias RawValue = String

}

public class PersistentStore<T: Codable & Identifiable> {

    private let defaults = UserDefaults.standard

    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()

    private let key: PersistentStoreKey

    public init(_ key: PersistentStoreKey) {
        self.key = key
    }

    public func store(_ item: T) {
        var items = (try? getData()) ?? []
        guard !items.contains(where: { $0.id == item.id }) else {
            return
        }
        items.append(item)
        try? setData(items)
    }

    @discardableResult
    public func delete(_ id: T.ID) -> T? {
        guard var data = try? getData() else {
            return nil
        }
        guard let itemIndex = data.firstIndex(where: {  $0.id == id }) else {
            return nil
        }
        let deletedItem = data.remove(at: itemIndex)
        try? setData(data)
        return deletedItem
    }

    public func getItems() -> [T] {
        (try? getData()) ?? []
    }

    private func getData() throws -> [T] {
        if let data = defaults.data(forKey: key.rawValue) {
            return try decoder.decode([T].self, from: data)
        }
        return []
    }

    private func setData(_ data: [T]) throws {
        let encoded = try encoder.encode(data)
        defaults.set(encoded, forKey: key.rawValue)
    }
}
