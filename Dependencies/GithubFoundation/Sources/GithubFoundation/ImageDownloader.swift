//
//  Created by Mateusz Matrejek.
//  Copyright © 2020 Mateusz Matrejek. All rights reserved.
//

import UIKit

public class ImageDownloader {

    public static let shared = ImageDownloader()

    private let cache = ImageCache()

    private let networkSession = NetworkSession.shared

    private init() { }

    public func fetchImage(with url: URL, completion: @escaping (UIImage) -> Void) {
        if let cachedImage = cache.image(for: url) {
            completion(cachedImage)
            return
        }
        networkSession.dataTask(url) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    self.cache.set(image, for: url)
                    completion(image)
                }
            case .failure:
                return
            }
        }.resume()
    }
}
