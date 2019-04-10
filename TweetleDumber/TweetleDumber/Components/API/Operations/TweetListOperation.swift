//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

struct TweetListOperation: APIOperation, BearerSignedOperation {
    struct Response: Codable {
        let tweets: [Identified<Tweet>]
    }
    
    func createRequest() throws -> HTTPRequest {
        return .init(method: .get, url: URL("tweets"))
    }
}
