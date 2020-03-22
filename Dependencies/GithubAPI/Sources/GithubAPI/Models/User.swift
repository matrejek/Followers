//
//  Created by Mateusz Matrejek
//

import Foundation

public struct User: Codable {
    public var login: String
    public var avatarUrl: String
    public var name: String?
    public var location: String?
    public var bio: String?
    public var publicRepos: Int
    public var publicGists: Int
    public var htmlUrl: String
    public var followers: Int
    public var following: Int
    public var createdAt: String
}
