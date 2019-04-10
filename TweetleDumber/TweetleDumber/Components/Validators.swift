//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

extension Validator {
    struct PasswordMismatch: Error { }
    
    static var passwords: Validator<(String, String), String> {
        return .init(validate: { first, second in
            guard first == second else { throw PasswordMismatch() }
            
            return try password.validate(first)
        })
    }
}

extension Validator {
    static var username: SimpleValidator<String> {
        return .count(atLeast: 5)
    }
    static var password: SimpleValidator<String> {
        return .containing(atLeast: 5, in: .alphanumerics)
    }
}

extension Validator {
    static func tweet(maxLength: Int) -> SimpleValidator<Tweet> {
        return .keyPath(\.message, .count(lessThanOrEqualTo: maxLength))
    }
}
