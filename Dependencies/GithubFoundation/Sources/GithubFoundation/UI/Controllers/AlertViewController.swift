//
//  Created by Mateusz Matrejek
//

import UIKit

class AlertViewController: UIViewController {

    private class AlertContainerView: UIView {

        override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }

        private func commonInit() {
            backgroundColor = .systemBackground
            layer.cornerRadius = 16
            layer.borderWidth = 2
            layer.borderColor = UIColor.white.cgColor
        }
    }

    @UsesAutoLayout
    private var containerView = AlertContainerView()

    @UsesAutoLayout
    private var elementsStackView = UIStackView.equallySpacedStackView()

    @UsesAutoLayout
    private var titleLabel = TitleLabel(textAlignment: .center, fontSize: 20)

    @UsesAutoLayout
    private var messageLabel = BodyLabel(textAlignment: .center)

    @UsesAutoLayout
    private var actionButton = Button()

    private var alertTitle: String?

    private var message: String?

    private var buttonTitle: String?

    public init(title: String, message: String, buttonTitle: String) {
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.alertTitle = NSLocalizedString("Something went wrong", comment: "alert_title")
        self.message = NSLocalizedString("Unable to complete operation", comment: "alert_button")
        self.buttonTitle = NSLocalizedString("OK", comment: "alert_action")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureElementsStackView()
        configureTitleLabel()
        configureMessageLabel()
        configureButton()
    }

    private func configureContainerView() {
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }

    private func configureElementsStackView() {
        containerView.addSubview(elementsStackView)
        let margin: CGFloat = 16.0
        NSLayoutConstraint.activate([
            elementsStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: margin),
            elementsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -margin),
            elementsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: margin),
            elementsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -margin)
        ])
    }

    private func configureButton() {
        elementsStackView.addArrangedSubview(actionButton)
        actionButton.backgroundColor = .systemPink
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 50.0),
            actionButton.widthAnchor.constraint(equalTo: elementsStackView.widthAnchor)
        ])
    }

    private func configureTitleLabel() {
        elementsStackView.addArrangedSubview(titleLabel)
        titleLabel.text = alertTitle
    }

    private func configureMessageLabel() {
        elementsStackView.addArrangedSubview(messageLabel)
        messageLabel.text = message
    }

    @objc
    private func dismissController() {
        dismiss(animated: true, completion: nil)
    }

}

public extension UIViewController {
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = AlertViewController(title: title, message: message, buttonTitle: buttonTitle)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
}
