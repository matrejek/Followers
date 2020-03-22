//
//  Created by Mateusz Matrejek
//

import Foundation

public class GithubUsersService {

    public typealias FollowersResult = Result<[Follower], Github.Error>
    public typealias FollowersCompletion = (FollowersResult) -> Void

    public typealias GetUserResult = Result<User, Github.Error>
    public typealias GetUserCompletion = (GetUserResult) -> Void

    static let shared = GithubUsersService()

    static let defaultServiceURL = URL(string: "https://api.github.com/users/")!

    private let endpoint: Endpoint

    init(url: URL = GithubUsersService.defaultServiceURL) {
        self.endpoint = Endpoint(url)
    }

    public func getFollowers(of username: String, page: Int = 1, completion: @escaping FollowersCompletion) {
        let followersRequest = FollowersRequest(username: username, page: page)
        endpoint.perform(followersRequest, completion: completion)
    }

    public func getUser(with username: String, completion: @escaping GetUserCompletion) {
        let userInfoRequest = UserDataRequest(username: username)
        endpoint.perform(userInfoRequest, completion: completion)
    }
}
