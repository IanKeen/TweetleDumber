//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

enum ApplicationState: Equatable {
    case pending
    case signedOut
    case signedIn(Authentication)
}

enum ApplicationEvent: Equatable {
    case signIn(Authentication)
    case signOut
}

typealias ApplicationStateMachine = StateMachine<ApplicationState, ApplicationEvent>
typealias ReadOnlyApplicationStateMachine = ReadOnlyStateMachine<ApplicationState, ApplicationEvent>

let DefaultStateMachine = ApplicationStateMachine(
    startingWith: .pending,
    transitions:
    
    ApplicationState.pending ~~> ApplicationEvent.signOut == ApplicationState.signedOut,
    ApplicationState.pending ~~> ApplicationEvent.signIn == ApplicationState.signedIn,
    ApplicationState.signedOut ~~> ApplicationEvent.signIn == ApplicationState.signedIn,
    ApplicationState.signedIn ~~> ApplicationEvent.signOut == ApplicationState.signedOut
)
