//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

protocol SignInViewModelInputs {
    var username: Input<String> { get }
    var password: Input<String> { get }
    var signIn: Input<Void> { get }
}

protocol SignInViewModelOutputs {
    var working: Output<Bool> { get }
    var errors: Output<Error> { get }
    
    var allowSignIn: Output<Bool> { get }
    var signedIn: Output<Void> { get }
}

class SignInViewModel: SignInViewModelInputs, SignInViewModelOutputs {
    // MARK: - Inputs
    let username: Input<String>
    let password: Input<String>
    let signIn: Input<Void>
    
    // MARK: - Outputs
    let working: Output<Bool>
    let errors: Output<Error>
    let allowSignIn: Output<Bool>
    let signedIn: Output<Void>
    
    // MARK: - Lifecycle
    init(session: Session) {
        let tracker = OutputTracker()
        let errors = Output<Error>.create()
        let username = Output<String>.create()
        let password = Output<String>.create()
        let signIn = Output<Void>.create()
        
        self.username = username.input
        self.password = password.input
        self.signIn = signIn.input
        
        let allowSignIn = Output
            .combineLatest(
                username.output.validated(by: .username),
                password.output.validated(by: .password),
                transform: { $0 && $1 }
            )
            .startsWith(false)
        
        let userPass = Output.combineLatest(username.output, password.output, transform: { ($0, $1) })
        
        self.allowSignIn = allowSignIn
        self.signedIn = signIn.output
            .filter(with: allowSignIn)
            .withLatestFrom(userPass)
            .flatMapLatest { username, password in
                return session.bindings.signIn(username: username, password: password)
                    .track(with: tracker)
                    .success(emitErrorsTo: errors.input)
            }
        
        self.working = tracker.output
        self.errors = errors.output
    }
}
