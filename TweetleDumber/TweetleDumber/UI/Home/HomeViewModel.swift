//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

protocol HomeViewModelInputs {
    var signOut: Input<Void> { get }
}

protocol HomeViewModelOutputs {
    //
}

class HomeViewModel: HomeViewModelInputs, HomeViewModelOutputs {
    // MARK: - Inputs
    let signOut: Input<Void>
    
    // MARK: - Outputs
    //
    
    // MARK: - Lifeycle
    init(session: Session) {
        self.signOut = .init {
            session.signOut()
        }
    }
}

