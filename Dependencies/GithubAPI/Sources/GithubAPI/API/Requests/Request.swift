//
//  Created by Mateusz Matrejek
//

import Foundation

protocol Request {

    var pathComponents: [String] { get }

    var queryItems: [URLQueryItem] { get }
}

extension Request {
    func httpRequest(with baseURL: URL) -> URLRequest? {
        let url = baseURL.appendingPathComponent(pathComponents.joined(separator: "/"))
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        components.queryItems = queryItems
        guard let requestURL = components.url else {
            return nil
        }
        return URLRequest(url: requestURL)
    }
}
