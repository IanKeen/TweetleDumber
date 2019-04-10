//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class LoadingViewController: UIViewController {
    typealias VM = ViewModel<LoadingViewModelInputs, LoadingViewModelOutputs>
    
    // MARK: - Private Properties
    private let viewModel: VM
    
    // MARK: - Lifecycle
    public required init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.viewModel.input.restoreSession()
        }
    }
}

