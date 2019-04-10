//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

protocol RootViewModelInputs {
    //
}

protocol RootViewModelOutputs {
    var rootUpdated: Output<RootType> { get }
}

enum RootType {
    case loading
    case authenticate
    case home(Identified<User>)
}

class RootViewModel: RootViewModelInputs, RootViewModelOutputs {
    // MARK: - Private Properties
    //
    
    // MARK: - Inputs
    //
    
    // MARK: - Outputs
    let rootUpdated: Output<RootType>
    
    // MARK: - Lifecycle
    init(stateMachine: ReadOnlyApplicationStateMachine) {
        self.rootUpdated = stateMachine.bindings.stateChange().map { state in
            switch state {
            case .pending: return .loading
            case .signedOut: return .authenticate
            case .signedIn(let auth): return .home(auth.user)
            }
        }
    }
}
