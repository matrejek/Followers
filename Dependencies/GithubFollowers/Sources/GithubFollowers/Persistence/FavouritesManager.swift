//
//  Created by Mateusz Matrejek
//

import Foundation
import GithubFoundation

class FavouritesManager {

    static let shared = FavouritesManager()

    struct Follower: Codable, Identifiable {

        init(login: String, avatarURL: String) {
            self.login = login
            self.avatarURL = avatarURL
        }

        var login: String
        var avatarURL: String

        var id: String {
            login
        }
    }

    typealias FetchResult = Result<[Follower], Never>
    typealias ActionCompletion = () -> Void
    typealias FetchCompletion = (FetchResult) -> Void

    private let store = PersistentStore<Follower>(.Favourites)

    private let queue = DispatchQueue(label: "FavouritesManager")

    func fetchFavourites(completion: @escaping FetchCompletion) {
        queue.async {
            completion(.success(self.store.getItems()))
        }
    }

    func addFavourite(_ follower: Follower, completion: @escaping ActionCompletion) {
        queue.async {
            self.store.store(follower)
            completion()
        }
    }

    func removeFavourite(_ username: String, completion: @escaping ActionCompletion) {
        queue.async {
            self.store.delete(username)
            completion()
        }
    }
}

extension PersistentStoreKey {
    static let Favourites =  PersistentStoreKey("favourites")!
}
