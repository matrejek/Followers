//
//  Created by Mateusz Matrejek
//

import GithubFoundation
import UIKit

protocol SearchViewControllerDelegate: AnyObject {
    func searchController(_ controller: SearchViewController, didEnter username: String)
}

class SearchViewController: UIViewController {

    weak var delegate: SearchViewControllerDelegate?

    @UsesAutoLayout
    private var stackView = UIStackView.equallySpacedStackView()

    @UsesAutoLayout
    private var logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "gh-logo")
        return view
    }()

    @UsesAutoLayout
    private var usernameTextField = TextField.usernameTextField()

    @UsesAutoLayout
    private var actionButton = Button.button(titled: NSLocalizedString("Get Followers", comment: "cta_title"),
                                             backgroundColor: .systemGreen)

    private var isUsernameEmpty: Bool {
        usernameTextField.text?.isEmpty ?? true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureStackView()
        configureImageView()
        configureTextField()
        configureButton()
        configureTapToDismiss()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configureStackView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80.0),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func configureTextField() {
        usernameTextField.addTarget(self, action: #selector(handleTextFieldChange), for: .editingChanged)
        usernameTextField.delegate = self
        stackView.addArrangedSubview(usernameTextField)
        NSLayoutConstraint.activate([
            usernameTextField.heightAnchor.constraint(equalToConstant: 50.0),
            usernameTextField.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
    }

    private func configureImageView() {
        stackView.addArrangedSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.6),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor)
        ])
    }

    private func configureButton() {
        actionButton.isEnabled = false
        actionButton.addTarget(self, action: #selector(triggerSearch), for: .touchUpInside)
        stackView.addArrangedSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 50.0),
            actionButton.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.7)
        ])
    }

    private func configureTapToDismiss() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }

    @objc
    private func handleTextFieldChange() {
        actionButton.isEnabled = !isUsernameEmpty
    }

    @objc
    private func triggerSearch() {
        guard let username = usernameTextField.text, username.isValidUsername else {
            handleInvalidUsername()
            return
        }
        view.endEditing(true)
        delegate?.searchController(self, didEnter: username)
    }

    private func handleInvalidUsername() {
        presentAlert(title: NSLocalizedString("Empty Username", comment: "error_title"),
                     message: NSLocalizedString("Please enter the username", comment: "error_msg"),
                     buttonTitle: NSLocalizedString("OK", comment: "error_cta"))
    }
}


extension SearchViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        triggerSearch()
        return true
    }
}
