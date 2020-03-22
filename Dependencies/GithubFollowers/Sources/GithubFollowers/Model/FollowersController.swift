//
//  Created by Mateusz Matrejek.
//  Copyright © 2020 Mateusz Matrejek. All rights reserved.
//

import UIKit

import GithubAPI
import GithubFoundation
import SafariServices

public class FollowersController {

    public lazy var favouritesController: UINavigationController = createFavouritesNavController()

    public lazy var searchController: UINavigationController = createSearchNavController()

    private let usersService = Github.users

    private let favouritesStore = FavouritesManager.shared

    public init() { }

    private func createSearchNavController() -> UINavigationController {
        let controller = SearchViewController()
        controller.delegate = self
        controller.title = NSLocalizedString("Search", comment: "search_title")
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: controller)
    }

    private func createFavouritesNavController() -> UINavigationController {
        let controller = FavouritesListViewController()
        controller.delegate = self
        controller.title = NSLocalizedString("Favourites", comment: "favourites_title")
        controller.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        defer { refreshFavourites() }
        return UINavigationController(rootViewController: controller)
    }

    private func pushFollowersController(for username: String, on navigationController: UINavigationController) -> FollowersViewController {
        let followersVC = FollowersViewController()
        followersVC.username = username
        followersVC.delegate = self
        navigationController.pushViewController(followersVC, animated: true)
        return followersVC
    }

    private func handle(_ result: GithubUsersService.FollowersResult, with controller: FollowersViewController) {
        controller.dismissLoadingView()
        switch result {
        case .success(let followers):
            let newFollowers = followers.map { FollowersViewController.ViewModel($0) }
            controller.followers.append(contentsOf: newFollowers)
        case .failure(let error):
            handle(error, with: controller)
        }
    }

    private func handle(_ result: GithubUsersService.GetUserResult, with controller: FollowersViewController) {
        switch result {
        case .success(let user):
            presentUserInfoController(for: user, on: controller)
        case .failure(let error):
            handle(error, with: controller)
        }
    }

    private func handle(_ error: Github.Error, with controller: FollowersViewController) {
        controller.presentAlert(title: NSLocalizedString("Something went wrong", comment: "error_title"),
                                message: error.localizedDescription,
                                buttonTitle: NSLocalizedString("OK", comment: "error_cta"))
    }

    private func fetchUser(with username: String, for controller: FollowersViewController) {
        usersService.getUser(with: username) { [weak controller] result in
            guard let controller = controller else {
                return
            }
            self.handle(result, with: controller)
        }
    }

    private func fetchFollowers(for username: String, page: Int = 1, followersController: FollowersViewController) {
        followersController.showLoadingView()
        usersService.getFollowers(of: username, page: page) { [weak followersController] result in
            guard let controller = followersController else {
                return
            }
            self.handle(result, with: controller)
        }
    }

    private func presentUserInfoController(for user: User, on controller: FollowersViewController) {
        DispatchQueue.main.async {
            let userController = UserInfoViewController(user: UserInfoViewController.ViewModel(user: user))
            userController.delegate = self
            controller.present(UINavigationController(rootViewController: userController), animated: true)
        }
    }

    private func presentSafariVC(with url: URL, using context: UIViewController) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        context.present(safariVC, animated: true)
    }

    private func refreshFavourites() {
        DispatchQueue.main.async {
            guard let target = self.favouritesController.viewControllers.last as? FavouritesListViewController else {
                return
            }
            self.favouritesStore.fetchFavourites { result in
                switch result {
                case .success(let favourites):
                    target.favourites = favourites.map { FavouritesListViewController.ViewModel(username: $0.login,
                                                                                                avatarURL: URL(string: $0.avatarURL)!)}
                case .failure:
                    target.favourites = []
                }
            }
        }
    }

    private func launchFollowersController(for username: String, from controller: UIViewController) {
        guard let navigationController = controller.navigationController else {
            return
        }
        let followersController = pushFollowersController(for: username, on: navigationController)
        followersController.showLoadingView()
        fetchFollowers(for: username, followersController: followersController)
    }
}

extension FollowersController: SearchViewControllerDelegate {

    func searchController(_ controller: SearchViewController, didEnter username: String) {
        launchFollowersController(for: username, from: controller)
    }
}

extension FollowersController: FollowersViewControllerDelegate {

    func followersViewControllerDidRequestFetchingFollowers(_ controller: FollowersViewController) {
        let page = controller.followers.count / 100 + 1
        fetchFollowers(for: controller.username, page: page, followersController: controller)
    }

    func followersViewController(_ controller: FollowersViewController, didSelect username: String) {
        fetchUser(with: username, for: controller)
    }

    func followersViewController(_ controller: FollowersViewController, didToggleFavourite user: String) {
        usersService.getUser(with: user) { result in
            switch result {
            case .success(let user):
                let favourite = FavouritesManager.Follower(login: user.login, avatarURL: user.avatarUrl)
                self.favouritesStore.addFavourite(favourite, completion: self.refreshFavourites)
            case .failure:
                return
            }

        }
    }
}

extension FollowersController: UserInfoViewControllerDelegate {
    func controller(_ controller: UserInfoViewController, didRequestProfile url: URL) {
        presentSafariVC(with: url, using: controller)
    }

    func controller(_ controller: UserInfoViewController, didRequestFollowers username: String) {
        guard let target = searchController.viewControllers.last as? FollowersViewController else {
            return
        }
        controller.dismiss(animated: true)
        usersService.getFollowers(of: username) { result in
            target.username = username
            target.followers = []
            self.handle(result, with: target)
        }
    }
}

extension FollowersController: FavouritesListViewControllerDelegate {

    func favouritesController(_ controller: FavouritesListViewController, didRequestFollowers username: String) {
        launchFollowersController(for: username, from: controller)
    }

    func favouritesController(_ controller: FavouritesListViewController, didRequestDeletion favourite: String) {
        favouritesStore.removeFavourite(favourite) {
            self.refreshFavourites()
        }
    }
}
