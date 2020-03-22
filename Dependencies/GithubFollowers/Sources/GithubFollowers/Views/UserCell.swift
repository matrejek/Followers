//
//  Created by Mateusz Matrejek
//
import GithubFoundation
import UIKit

class UserCell: UICollectionViewCell {

    static let reuseId = "FollowerCell"

    @UsesAutoLayout
    private var avatarView = AvatarView()

    @UsesAutoLayout
    private var nameLabel = TitleLabel(textAlignment: .center, fontSize: 16.0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    private func configure() {
        addSubview(avatarView)
        addSubview(nameLabel)

        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            avatarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setup(with follower: FollowersViewController.ViewModel) {
        nameLabel.text = follower.username
        if let avatarURL = follower.avatarURL {
            avatarView.setupWith(avatarURL: avatarURL)
        }
    }

}
