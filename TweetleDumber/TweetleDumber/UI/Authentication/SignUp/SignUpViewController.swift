//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class SignUpViewController: UIViewController, CustomViewProvider {
    typealias CustomView = SignUpView
    typealias VM = ViewModel<SignUpViewModelInputs, SignUpViewModelOutputs>
    
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
        title = "Sign Up"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    // MARK: - Private Functions
    private func bindViewModel() {
        cancellables.append(
            customView.signUp.bindings.isEnabled << viewModel.output.allowSignUp,
            errorResponder << viewModel.output.errors,
            workingResponder << viewModel.output.working,
            
            customView.username.bindings.text >> viewModel.input.username,
            customView.password.bindings.text >> viewModel.input.password,
            customView.passwordConfirmation.bindings.text >> viewModel.input.passwordConfirmation,
            customView.signUp.bindings.tap >> viewModel.input.signUp
        )
    }
}
