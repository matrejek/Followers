//
//  Created by Mateusz Matrejek
//

import GithubFoundation
import UIKit

class UserInfoItem {

    struct Field {
        var symbol: String
        var label: String
        var value: Int
    }

    struct Action {
        let name: String
        let tintColor: UIColor
        let handler: () -> Void
    }

    var primary: Field
    var secondary: Field
    var action: Action?

    init(primary: Field, secondary: Field) {
        self.primary = primary
        self.secondary = secondary
    }
}

class UserInfoItemViewController<T: UserInfoItem>: UIViewController {

    private typealias ButtonHandler = () -> Void

    private class UserInfoView: UIView {

        @UsesAutoLayout
        var symbolImageView = UIImageView()
        @UsesAutoLayout
        var titleLabel = TitleLabel(textAlignment: .left, fontSize: 14)
        @UsesAutoLayout
        var countLabel = TitleLabel(textAlignment: .center, fontSize: 14)


        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }


        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func setup(item: UserInfoItem.Field) {
            symbolImageView.image = UIImage(systemName: item.symbol)
            titleLabel.text = item.label
            countLabel.text = String(format: "%d", item.value)
        }

        private func configure() {
            addSubviews(symbolImageView, titleLabel, countLabel)

            symbolImageView.translatesAutoresizingMaskIntoConstraints = false
            symbolImageView.contentMode = .scaleAspectFill
            symbolImageView.tintColor = .label

            NSLayoutConstraint.activate([
                symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
                symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                symbolImageView.widthAnchor.constraint(equalToConstant: 20),
                symbolImageView.heightAnchor.constraint(equalToConstant: 20),

                titleLabel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                titleLabel.heightAnchor.constraint(equalToConstant: 18),

                countLabel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
                countLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                countLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                countLabel.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
    }

    @UsesAutoLayout
    private var stackView = UIStackView()
    @UsesAutoLayout
    private var itemInfoViewOne = UserInfoView()
    @UsesAutoLayout
    private var itemInfoViewTwo = UserInfoView()
    @UsesAutoLayout
    private var actionButton = Button()

    private var buttonHandler: ButtonHandler?

    init(_ data: T) {
        super.init(nibName: nil, bundle: nil)
        configure(with: data)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundView()
        layoutUI()
        configureStackView()
    }

    private func configure(with data: T) {
        itemInfoViewOne.setup(item: data.primary)
        itemInfoViewTwo.setup(item: data.secondary)
        if let action = data.action {
            configureButton(with: action)
        }
    }

    private func configureButton(with action: UserInfoItem.Action) {
        actionButton.setTitle(action.name, for: .normal)
        actionButton.backgroundColor = action.tintColor
        buttonHandler = action.handler
        actionButton.addTarget(self, action: #selector(invokeButtonAction), for: .touchUpInside)
    }

    @objc
    private func invokeButtonAction() {
        buttonHandler?()
    }

    private func configureBackgroundView() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }


    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }

    private func layoutUI() {
        view.addSubviews(stackView, actionButton)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
