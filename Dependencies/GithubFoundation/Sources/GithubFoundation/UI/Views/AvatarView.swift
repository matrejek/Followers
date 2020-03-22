//
//  Created by Mateusz Matrejek
//

import UIKit

public class AvatarView: UIImageView {

    private var placeholderImage: UIImage?

    public init(placeholderImage: UIImage?) {
        super.init(frame: .zero)
        self.placeholderImage = placeholderImage
        commonInit()
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 10
        clipsToBounds  = true
        image = placeholderImage
    }

}
