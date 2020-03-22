//
//  Created by Mateusz Matrejek
//

import Foundation
import GithubFoundation

public struct Github {

    public enum Error: Swift.Error {
        case invalidRequest
        case networkFailure
        case apiError
        case badResponse

        public var localizedDescription: String {
            switch self {
            case .networkFailure:
                return "netowrk"
            case .apiError:
                return "api"
            case .badResponse:
                return "respo"
            case .invalidRequest:
                return "request"
            }
        }

        static func fromNetworkError(_ error: NetworkSession.Error) -> Github.Error {
            switch error {
            case .apiError:
                return .apiError
            case .networkFailure:
                return .networkFailure
            case .badResponse:
                return .badResponse
            }
        }
    }

    public static let users = GithubUsersService.shared
}
