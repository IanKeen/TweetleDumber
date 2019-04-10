//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

protocol SignUpViewModelInputs {
    var username: Input<String> { get }
    var password: Input<String> { get }
    var passwordConfirmation: Input<String> { get }
    var signUp: Input<Void> { get }
}

protocol SignUpViewModelOutputs {
    var working: Output<Bool> { get }
    var errors: Output<Error> { get }
    
    var allowSignUp: Output<Bool> { get }
    var signedUp: Output<Void> { get }
}

class SignUpViewModel: SignUpViewModelInputs, SignUpViewModelOutputs {
    // MARK: - Inputs
    let username: Input<String>
    let password: Input<String>
    let passwordConfirmation: Input<String>
    let signUp: Input<Void>
    
    // MARK: - Outputs
    let working: Output<Bool>
    let errors: Output<Error>
    let allowSignUp: Output<Bool>
    let signedUp: Output<Void>
    
    // MARK: - Lifecycle
    init(session: Session) {
        let tracker = OutputTracker()
        let errors = Output<Error>.create()
        let username = Output<String>.create()
        let password = Output<String>.create()
        let passwordConfirmation = Output<String>.create()
        let signUp = Output<Void>.create()
        
        self.username = username.input
        self.password = password.input
        self.passwordConfirmation = passwordConfirmation.input
        self.signUp = signUp.input
        
        let passwords = Output.combineLatest(password.output, passwordConfirmation.output) { ($0, $1) }
        
        let allowSignUp = Output
            .combineLatest(
                username.output.validated(by: .username),
                passwords.validated(by: .passwords),
                transform: { $0 && $1 }
            )
            .startsWith(false)
        
        let userPass = Output.combineLatest(username.output, password.output, transform: { ($0, $1) })
        
        self.allowSignUp = allowSignUp
        self.signedUp = signUp.output
            .filter(with: allowSignUp)
            .withLatestFrom(userPass)
            .flatMapLatest { username, password in
                return session.bindings.signUp(username: username, password: password)
                    .track(with: tracker)
                    .success(emitErrorsTo: errors.input)
        }
        
        self.working = tracker.output
        self.errors = errors.output
    }
}
