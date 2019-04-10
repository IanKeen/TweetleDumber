//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

struct Tweet: Equatable, Codable {
    let user: Identified<User>
    let timestamp: Date
    let message: String
}
