//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

struct TweetOperation: APIOperation, BearerSignedOperation {
    typealias Response = Identified<Tweet>
    
    private let tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func createRequest() throws -> HTTPRequest {
        return .init(method: .post, url: URL("tweets"), body: .json(tweet))
    }
}
