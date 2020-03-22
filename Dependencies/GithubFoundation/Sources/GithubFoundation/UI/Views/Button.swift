//
//  Created by Mateusz Matrejek
//

import UIKit

public class Button: UIButton {

    public override var isEnabled: Bool {
        get {
            super.isEnabled
        }
        set {
            DispatchQueue.main.async { self.alpha = newValue ? 1.0 : 0.5 }
            super.isEnabled = newValue
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        layer.cornerRadius = 10.0
        titleLabel?.textColor = .white
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
}

public extension Button {
    class func button(titled title: String, backgroundColor: UIColor) -> Button {
        let button = Button(frame: .zero)
        button.backgroundColor = backgroundColor
        button.setTitle(title, for: .normal)
        return button
    }
}
