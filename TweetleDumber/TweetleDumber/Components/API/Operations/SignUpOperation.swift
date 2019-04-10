//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

struct SignUpOperation: APIOperation {
    typealias Response = Authentication
    
    private struct Request: Encodable {
        let username: String
        let password: String
    }
    private let request: Request
    
    init(username: String, password: String) {
        self.request = Request(username: username, password: password)
    }
    
    func createRequest() throws -> HTTPRequest {
        return .init(method: .post, url: URL("signUp"), body: .json(request))
    }
}
