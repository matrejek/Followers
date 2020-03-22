//
//  Created by Mateusz Matrejek
//

import UIKit

public extension UIStackView {
    class func equallySpacedStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }
}
