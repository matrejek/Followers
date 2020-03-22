//
//  Created by Mateusz Matrejek.
//  Copyright © 2020 Mateusz Matrejek. All rights reserved.
//

import GithubFoundation
import UIKit
class UserInfoHeaderViewController: UIViewController {

    struct UserBasicData {
        var username: String
        var name: String?
        var location: String?
        var bio: String?
        var avatarURL: URL?
        var profileURL: URL?
    }

    @UsesAutoLayout
    private var avatarImageView = AvatarView()
    @UsesAutoLayout
    private var usernameLabel = TitleLabel(textAlignment: .left, fontSize: 34)
    @UsesAutoLayout
    private var nameLabel = SubtitleLabel(fontSize: 18)
    @UsesAutoLayout
    private var locationImageView = UIImageView()
    @UsesAutoLayout
    private var locationLabel = SubtitleLabel(fontSize: 18)
    @UsesAutoLayout
    private var bioLabel = BodyLabel(textAlignment: .left)

    private let viewModel: UserBasicData

    init(_ userData: UserBasicData) {
        viewModel = userData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupValues()
        layoutUI()
    }

    private func addSubviews() {
        view.addSubview(avatarImageView)
        view.addSubview(usernameLabel)
        view.addSubview(nameLabel)
        view.addSubview(locationImageView)
        view.addSubview(locationLabel)
        view.addSubview(bioLabel)
    }

    private func setupValues() {
        if let avatarURL = viewModel.avatarURL {
            avatarImageView.setupWith(avatarURL: avatarURL)
        }
        usernameLabel.text = viewModel.username
        nameLabel.text = viewModel.name ?? ""
        locationLabel.text = viewModel.location ?? NSLocalizedString("No Location", comment: "No Location")
        bioLabel.text = viewModel.bio ?? NSLocalizedString("No bio available", comment: "No bio available")
        bioLabel.numberOfLines = 3

        locationImageView.image = UIImage(systemName: Symbol.location)
        locationImageView.tintColor = .secondaryLabel
    }

    private func layoutUI() {
        let padding: CGFloat            = 20
        let textImagePadding: CGFloat   = 12
        locationImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),

            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),

            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: textImagePadding),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),

            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),

            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: textImagePadding),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
