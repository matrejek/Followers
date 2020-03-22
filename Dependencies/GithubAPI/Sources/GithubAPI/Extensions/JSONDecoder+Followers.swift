//
//  Created by Mateusz Matrejek
//

import Foundation

extension JSONDecoder {
    class func githubApiDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
