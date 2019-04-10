//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class AuthenticationViewController: UITabBarController {
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    private func configure() {
        let signInViewModel = SignInViewController.VM {
            return try! SignInViewModel(session: Dependencies.default.resolve())
        }
        let signUpViewModel = SignUpViewController.VM {
            return try! SignUpViewModel(session: Dependencies.default.resolve())
        }
        let viewControllers = [
            SignInViewController(viewModel: signInViewModel),
            SignUpViewController(viewModel: signUpViewModel)
        ]
        setViewControllers(viewControllers, animated: false)
    }
}
