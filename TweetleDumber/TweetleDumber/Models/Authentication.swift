//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

struct Authentication: Codable, Equatable, UniquelyStorable {
    let token: String
    let user: Identified<User>
}
