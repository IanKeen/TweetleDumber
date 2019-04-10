//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

struct User: Codable, Equatable {
    var name: String
    var handle: String
    var avatar: String
    var bio: String
    
    let following: Int
    let followers: Int
}
