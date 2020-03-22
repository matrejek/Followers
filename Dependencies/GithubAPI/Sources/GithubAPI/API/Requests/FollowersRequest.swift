//
//  Created by Mateusz Matrejek
//

import Foundation

class UserDataRequest: Request {

    private let username: String

    var pathComponents: [String] {
        [username]
    }

    var queryItems: [URLQueryItem] {
        []
    }

    init(username: String) {
        self.username = username
    }
}

class FollowersRequest: UserDataRequest {

    override var pathComponents: [String] {
        super.pathComponents + ["followers"]
    }

    override var queryItems: [URLQueryItem] {
        super.queryItems + [pageSizeItem, pageNumberItem]
    }

    private let page: Int

    private var pageNumberItem: URLQueryItem {
        URLQueryItem(name: "page", value: String(page))
    }

    private var pageSizeItem: URLQueryItem {
        URLQueryItem(name: "per_page", value: String(100))
    }

    init(username: String, page: Int) {
        self.page = page
        super.init(username: username)
    }
}
