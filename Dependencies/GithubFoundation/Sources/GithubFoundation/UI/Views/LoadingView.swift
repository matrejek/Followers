//
//  Created by Mateusz Matrejek
//

import UIKit

class LoadingView: UIView {

    @UsesAutoLayout
    private var spinner = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(spinner)
        backgroundColor = .systemBackground
        alpha = 0
        NSLayoutConstraint.activate([
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        spinner.startAnimating()
    }
}
