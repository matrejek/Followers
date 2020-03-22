//
//  Created by Mateusz Matrejek
//

import GithubFoundation
import UIKit

extension AvatarView {

    convenience init() {
        self.init(placeholderImage: UIImage(named: "avatar-placeholder"))
    }

    func setupWith(avatarURL: URL) {
        ImageDownloader.shared.fetchImage(with: avatarURL) { newImage in
            DispatchQueue.main.async { self.image = newImage }
        }
    }
}
