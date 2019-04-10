//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class ComposeTweetNavigationController: UINavigationController {
    // MARK: - Lifecycle
    required init(user: Identified<User>) {
        let viewModel = ComposeTweetViewController.VM {
            return try! ComposeTweetViewModel(user: user, dateFactory: Dependencies.default.resolve(), apiClient: Dependencies.default.resolve())
        }
        let viewController = ComposeTweetViewController(viewModel: viewModel)
        
        super.init(nibName: nil, bundle: nil)
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        setViewControllers([viewController], animated: false)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIResponder
    override func tweetCompleted(_ tweet: ResponderBox) {
        dismiss(animated: true, completion: nil)
        next?.tweetCompleted(tweet)
    }
}
