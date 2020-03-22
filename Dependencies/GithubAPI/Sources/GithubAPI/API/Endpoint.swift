//
//  Created by Mateusz Matrejek
//

import Foundation
import GithubFoundation

class Endpoint {

    private var session: NetworkSession

    private var endpointURL: URL

    private let decoder = JSONDecoder.githubApiDecoder()

    init(_ endpointURL: URL, networkSession: NetworkSession = NetworkSession.shared) {
        self.endpointURL = endpointURL
        self.session = networkSession
    }

    func perform<T: Codable>(_ request: Request, completion: @escaping (Result<T, Github.Error>) -> Void) {
        guard let urlRequest = request.httpRequest(with: endpointURL) else {
            self.completeBy(calling: completion, with: .failure(.invalidRequest))
            return
        }
        let dataTask = session.dataTask(urlRequest) { result in
            switch result {
            case .success(let data):
                guard let response = try? self.decoder.decode(T.self, from: data) else {
                    self.completeBy(calling: completion, with: .failure(.badResponse))
                    return
                }
                self.completeBy(calling: completion, with: .success(response))
            case .failure(let error):
                self.completeBy(calling: completion, with: .failure(Github.Error.fromNetworkError(error)))
            }
        }
        dataTask.resume()
    }

    private func completeBy<T: Codable>(calling completion: @escaping (Result<T, Github.Error>) -> Void, with result: Result<T, Github.Error>) {
        DispatchQueue.main.async { completion(result) }
    }
}

