//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

struct TweetRepliesOperation: APIOperation, BearerSignedOperation {
    struct Response: Codable {
        let tweets: [Identified<Tweet>]
    }
    
    private let id: Identifier<Tweet>
    
    init(id: Identifier<Tweet>) {
        self.id = id
    }
    
    func createRequest() throws -> HTTPRequest {
        return .init(method: .get, url: URL("tweets/\(id.rawValue)"))
    }
}
