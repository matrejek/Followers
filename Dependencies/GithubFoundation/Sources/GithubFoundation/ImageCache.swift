//
//  Created by Mateusz Matrejek.
//  Copyright © 2020 Mateusz Matrejek. All rights reserved.
//

import UIKit

class ImageCache {

    private let cache = NSCache<NSString, UIImage>()

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: ImageCache.key(from: url))
    }

    func set(_ image: UIImage, for key: URL) {
        cache.setObject(image, forKey: ImageCache.key(from: key))
    }

    private static func key(from url: URL) -> NSString {
        NSString(string: url.absoluteString)
    }
}
