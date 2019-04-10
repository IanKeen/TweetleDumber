//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation

protocol LoadingViewModelInputs {
    func restoreSession()
}

protocol LoadingViewModelOutputs {
    //
}

class LoadingViewModel: LoadingViewModelInputs, LoadingViewModelOutputs {
    // MARK: - Private Properties
    private let session: Session
    
    // MARK: - Lifecycle
    init(session: Session) {
        self.session = session
    }
    
    // MARK: - Inputs
    func restoreSession() {
        session.restoreSession()
    }
    
    // MARK: - Outputs
    //
}
