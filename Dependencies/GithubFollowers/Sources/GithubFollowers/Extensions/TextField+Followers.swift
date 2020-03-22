//
//  Created by Mateusz Matrejek.
//  Copyright © 2020 Mateusz Matrejek. All rights reserved.
//

import Foundation
import GithubFoundation

extension TextField {
    class func usernameTextField() -> TextField {
        let textField = TextField(frame: .zero)
        textField.placeholder = NSLocalizedString("Enter Username", comment: "username_prompt")
        textField.returnKeyType = .go
        return textField
    }
}
