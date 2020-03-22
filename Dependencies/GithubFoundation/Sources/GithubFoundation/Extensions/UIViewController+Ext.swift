//
//  Created by Mateusz Matrejek
//

import UIKit

public extension UIViewController {

    var loadingView: UIView? {
        view.firstSubview(of: LoadingView.self)
    }

    func showLoadingView() {
        guard loadingView == nil else {
            return
        }
        let loadingView = LoadingView(frame: view.bounds)
        view.addSubview(loadingView)
        UIView.animate(withDuration: 0.25) {
            loadingView.alpha = 0.8
        }
    }

    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
        }
    }
}

public extension UIViewController {

    var emptyStateView: UIView? {
        view.firstSubview(of: EmptyStateView.self)
    }

    func showEmptyStateView(with message: String) {
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }

    func dismissEmptyStateView() {
        self.emptyStateView?.removeFromSuperview()
    }
}
