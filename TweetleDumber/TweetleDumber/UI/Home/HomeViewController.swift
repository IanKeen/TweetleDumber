//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class HomeViewController: UINavigationController {
    // MARK: - Private Properties
    private let viewModel = ViewModel<HomeViewModelInputs, HomeViewModelOutputs> {
        return try! HomeViewModel(session: Dependencies.default.resolve())
    }
    private let user: Identified<User>
    
    // MARK: - Lifecycle
    init(user: Identified<User>) {
        self.user = user        
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewModel = TweetListViewController.VM {
            return try! TweetListViewModel(apiClient: Dependencies.default.resolve(), formatter: Dependencies.default.resolve())
        }
        let viewController = TweetListViewController(viewModel: listViewModel)
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain) { [unowned self] _ in
            let profileViewModel = ProfileViewController.VM {
                return try! ProfileViewModel(user: self.user, apiClient: Dependencies.default.resolve(), formatter: Dependencies.default.resolve())
            }
            let profileViewController = ProfileViewController(viewModel: profileViewModel)
            self.pushViewController(profileViewController, animated: true)
        }
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain) { [unowned self] _ in
            self.viewModel.input.signOut.send(())
        }
        
        setViewControllers([viewController], animated: false)
    }
    
    // MARK: - UIResponder
    override func tweetSelected(_ tweet: ResponderBox) {
        let viewModel = TweetDetailsViewController.VM {
            return try! TweetDetailsViewModel(tweet: tweet.value(), apiClient: Dependencies.default.resolve(), formatter: Dependencies.default.resolve())
        }
        pushViewController(TweetDetailsViewController(viewModel: viewModel), animated: true)
    }
    override func composeTweet() {
        present(ComposeTweetNavigationController(user: user), animated: true, completion: nil)
    }
    override func tweetCompleted(_ tweet: ResponderBox) {
        viewControllers.firstMapping({ $0 as? TweetListViewController })?.tweetCompleted(tweet)
    }
}
