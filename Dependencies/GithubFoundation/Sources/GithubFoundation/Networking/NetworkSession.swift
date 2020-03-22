//
//  Created by Mateusz Matrejek
//

import Foundation

public class NetworkSession {

    public enum Error: Swift.Error {
        case networkFailure
        case apiError
        case badResponse
    }

    public static let shared = NetworkSession()

    private let underlyingSession = URLSession.shared

    private init() { }

    public func dataTask(_ url: URL, completion: @escaping (Result<Data, NetworkSession.Error>) -> Void) -> URLSessionDataTask {
        return dataTask(URLRequest(url: url), completion: completion)
    }

    public func dataTask(_ request: URLRequest, completion: @escaping (Result<Data, NetworkSession.Error>) -> Void) -> URLSessionDataTask {
        underlyingSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.networkFailure))
                return
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.apiError))
                return
            }
            guard let responseData = data else {
                completion(.failure(.badResponse))
                return
            }
            completion(.success(responseData))
        }
    }
}
