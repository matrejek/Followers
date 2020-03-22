//
//  Created by Mateusz Matrejek
//

import UIKit
import GithubFoundation
import GithubFollowers

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var followersController = FollowersController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        setupAppAppearance()
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBarController()
        window?.makeKeyAndVisible()
    }

    private func createTabBarController() -> UITabBarController {
        let controller = UITabBarController()
        controller.viewControllers = [followersController.searchController, followersController.favouritesController]
        return controller
    }

    private func setupAppAppearance() {
        UITabBar.appearance().tintColor = . systemGreen
        UINavigationBar.appearance().tintColor = .systemGreen
    }
}

