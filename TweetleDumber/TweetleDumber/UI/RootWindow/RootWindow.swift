//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class RootWindow: UIWindow {
    // MARK: - Private Properties
    private let viewModel = ViewModel<RootViewModelInputs, RootViewModelOutputs> {
        return try! RootViewModel(stateMachine: Dependencies.default.resolve())
    }
    private let cancellables = CancellableBag()
    
    // MARK: - Lifecycle
    init() {
        super.init(frame: UIScreen.main.bounds)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    // MARK: - UIResponder
    override func handleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.displayDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.topMostViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    private func configure() {
        viewModel.output
            .rootUpdated
            .subscribe { [unowned self] type in
                switch type {
                case .loading:
                    let viewModel = LoadingViewController.VM {
                        return try! LoadingViewModel(session: Dependencies.default.resolve())
                    }
                    self.setRootViewController(to: LoadingViewController(viewModel: viewModel))
                    
                case .authenticate:
                    self.setRootViewController(to: AuthenticationViewController())
                    
                case .home(let user):
                    self.setRootViewController(to: HomeViewController(user: user))
                }
                self.makeKeyAndVisible()
            }
            .add(to: cancellables)
        
        NotificationCenter.default.bindings
            .notifications(for: .blockingActivityWindowWillShow)
            .subscribe { _ in
                UIApplication.shared.keyWindow?.endEditing(true)
            }
            .add(to: cancellables)
    }
}
