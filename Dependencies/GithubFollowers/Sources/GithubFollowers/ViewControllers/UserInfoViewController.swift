//
//  Created by Mateusz Matrejek
//

import GithubAPI
import GithubFoundation
import UIKit

protocol UserInfoViewControllerDelegate: AnyObject {
    func controller(_ controller: UserInfoViewController, didRequestProfile url: URL)
    func controller(_ controller: UserInfoViewController, didRequestFollowers username: String)
}

public class UserInfoViewController: UIViewController {

    fileprivate class SocialInfoItem: UserInfoItem {

        init(followersCount: Int, followingCount: Int) {
            super.init(primary: UserInfoItem.Field(symbol: Symbol.followers,
                                                   label: NSLocalizedString("Followers", comment: "Followers"),
                                                   value: followersCount),
                       secondary: UserInfoItem.Field(symbol: Symbol.following,
                                                     label: NSLocalizedString("Following", comment: "Following"),
                                                     value: followingCount))
        }
    }

    fileprivate class ArtifactsInfoItem: UserInfoItem {
        init(reposCount: Int, gistsCount: Int) {
            super.init(primary: UserInfoItem.Field(symbol: Symbol.repos,
                                                   label: NSLocalizedString("Public Repos", comment: "Public Repos"),
                                                   value: reposCount),
                       secondary: UserInfoItem.Field(symbol: Symbol.gists,
                                                     label: NSLocalizedString("Public Gists", comment: "Public Gists"),
                                                     value: gistsCount))
        }
    }

    weak var delegate: UserInfoViewControllerDelegate?

    struct ViewModel {

        private let username: String
        private let name: String?
        private let avatarURL: URL?
        private let enrollmentDate: Date?
        private let bio: String?
        private let location: String?
        private let followers: Int
        private let following: Int
        private let repos: Int
        private let gists: Int
        private let profileURL: URL?


        init(user: User) {
            username = user.login
            avatarURL = URL(string: user.avatarUrl)
            name = user.name
            enrollmentDate = user.createdAt.convertToDate()
            bio = user.bio
            location = user.location
            followers = user.followers
            following = user.following
            repos = user.publicRepos
            gists = user.publicGists
            profileURL = URL(string: user.htmlUrl)
        }

        var basicData: UserInfoHeaderViewController.UserBasicData {
            UserInfoHeaderViewController.UserBasicData(username: username,
                                                       name: name,
                                                       location: location,
                                                       bio: bio,
                                                       avatarURL: avatarURL,
                                                       profileURL: profileURL)
        }

        fileprivate var followersData: SocialInfoItem {
            SocialInfoItem(followersCount: followers, followingCount: following)
        }

        fileprivate var reposData: ArtifactsInfoItem {
            ArtifactsInfoItem(reposCount: repos, gistsCount: gists)
        }

        var enrollmentDateString: String {
            guard let date = enrollmentDate else {
                return NSLocalizedString("N/A", comment: "N/A")
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let stringFormat = NSLocalizedString("GitHub since %@", comment: "GitHub since %@")
            return String(format: stringFormat, formatter.string(from: date))
        }
    }

    @UsesAutoLayout
    private var scrollView = UIScrollView()
    @UsesAutoLayout
    private var contentView = UIView()
    @UsesAutoLayout
    private var headerView = UIView()
    @UsesAutoLayout
    private var itemViewOne = UIView()
    @UsesAutoLayout
    private var itemViewTwo = UIView()
    @UsesAutoLayout
    private var dateLabel = BodyLabel(textAlignment: .center)

    private var itemViews: [UIView] = []

    private let viewModel: ViewModel

    init(user: UserInfoViewController.ViewModel) {
        self.viewModel = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        setupHeaderView()
        setupFollowersView()
        setupRepositoriesView()
        setupDateLabel()
        setupLayout()
    }

    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                            target: self,
                                                            action: #selector(dismssVC))
    }

    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }

    private func setupHeaderView() {
        self.add(childVC: UserInfoHeaderViewController(viewModel.basicData), to: self.headerView)
    }

    private func setupFollowersView() {
        let item = viewModel.followersData
        item.action = getFollowersAction
        self.add(childVC: UserInfoItemViewController(item), to: self.itemViewOne)
    }

    private func setupRepositoriesView() {
        let item = viewModel.reposData
        item.action = showProfileAction
        self.add(childVC: UserInfoItemViewController(item), to: self.itemViewTwo)
    }

    private func setupDateLabel() {
        dateLabel.text = viewModel.enrollmentDateString
    }

    private func setupLayout() {

        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        let headerHeight: CGFloat = 180
        let dateLabelHeight: CGFloat = 18

        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        itemViews.forEach { itemView in
            contentView.addSubview(itemView)
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
            ])
        }

         NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerHeight),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: dateLabelHeight)
        ])
    }

    private func requestUserProfile() {
        if let profileURL = viewModel.basicData.profileURL {
            delegate?.controller(self, didRequestProfile: profileURL)
        }
    }

    private func requestUserFollowers() {
        delegate?.controller(self, didRequestFollowers: self.viewModel.basicData.username)
    }

    @objc
    private func dismssVC() {
        dismiss(animated: true)
    }
}

extension UserInfoViewController {
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}

extension UserInfoViewController {
    var getFollowersAction: UserInfoItem.Action {
        UserInfoItem.Action(name: NSLocalizedString("Get Followers", comment: "Get Followers"),
                            tintColor: .systemGreen) {[weak self] in self?.requestUserFollowers() }
    }

    var showProfileAction: UserInfoItem.Action {
        UserInfoItem.Action(name: NSLocalizedString("GitHub Profile", comment: "GitHub Profile"),
                            tintColor: .systemPurple) { [weak self] in self?.requestUserProfile() }
    }
}
