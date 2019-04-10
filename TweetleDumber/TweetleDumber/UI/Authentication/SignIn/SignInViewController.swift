//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class SignInViewController: UIViewController, CustomViewProvider {
    typealias CustomView = SignInView
    typealias VM = ViewModel<SignInViewModelInputs, SignInViewModelOutputs>

    // MARK: - Private Properties
    private let viewModel: VM
    private let cancellables = CancellableBag()
    
    // MARK: - Lifecycle
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        title = "Sign In"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureInputFields()
        enableKeyboardSupport()
        bindViewModel()
    }
    
    // MARK: - Private Functions
    private func bindViewModel() {
        cancellables.append(
            customView.signIn.bindings.isEnabled << viewModel.output.allowSignIn,
            errorResponder << viewModel.output.errors,
            workingResponder << viewModel.output.working,
            
            customView.username.bindings.text >> viewModel.input.username,
            customView.password.bindings.text >> viewModel.input.password,
            customView.signIn.bindings.tap >> viewModel.input.signIn
        )
    }
}
