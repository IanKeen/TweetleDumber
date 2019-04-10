//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

struct UserTweetsOperation: APIOperation, BearerSignedOperation {
    struct Response: Codable {
        let tweets: [Identified<Tweet>]
    }
    
    private let id: Identifier<User>
    
    init(id: Identifier<User>) {
        self.id = id
    }
    
    func createRequest() throws -> HTTPRequest {
        return .init(method: .get, url: URL("users/\(id.rawValue)/tweets"))
    }
}
