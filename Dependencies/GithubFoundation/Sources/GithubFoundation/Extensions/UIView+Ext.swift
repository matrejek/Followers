//
//  Created by Mateusz Matrejek
//

import UIKit

public extension UIView {

    func pinToEdges(of superview: UIView) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }


    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}

public extension UIView {
    func firstSubview<T: UIView>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T }.first
    }
}
