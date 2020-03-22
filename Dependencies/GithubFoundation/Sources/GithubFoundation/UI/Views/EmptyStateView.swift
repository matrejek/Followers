//
//  Created by Mateusz Matrejek
//

import UIKit

class EmptyStateView: UIView {

    let messageLabel    = TitleLabel(textAlignment: .center, fontSize: 28)
    let logoImageView   = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }


    init(message: String) {
        super.init(frame: .zero)
        messageLabel.text = message
        commonInit()
    }


    private func commonInit() {
        addSubview(messageLabel)
        addSubview(logoImageView)

        messageLabel.numberOfLines  = 3
        messageLabel.textColor = .secondaryLabel

        logoImageView.image = UIImage(named: "empty-state-logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -150),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            messageLabel.heightAnchor.constraint(equalToConstant: 200),

            logoImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1.3),
            logoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 170),
            logoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 40)
        ])
    }
}
