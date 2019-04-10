//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

// MARK: - User

extension User {
    private static let names = [
        "Rhys Kaye", "Inaaya Bernal", "Brandi Fitzgerald", "Maya Byers", "Rajan Villegas",
        "Trent Dunne", "Talha Stone", "Jayde Melendez", "Jaskaran Mcgregor", "Huey Morales"
    ]
    
    static func random() -> User {
        let name = User.names.randomElement()!
        return User(
            name: name,
            handle: "@\(name.replacingOccurrences(of: " ", with: ""))",
            avatar: "https://api.adorable.io/avatars/285/\(name.replacingOccurrences(of: " ", with: "%20")).png",
            bio: Lorem.Ipsum[.sentences(4)],
            following: Int.random(in: 0...100),
            followers: Int.random(in: 0...100)
        )
    }
}

extension Identified where T == User {
    static func random() -> Identified<User> {
        let user = User.random()
        
        return .init(
            identifier: .init(rawValue: user.name.data(using: .utf8)!.base64EncodedString()),
            value: user
        )
    }
}

// MARK: - Tweet

extension Tweet {
    static func random(user: Identified<User>? = nil) -> Tweet {
        return Tweet(
            user: user ?? .random(),
            timestamp: Date.random(),
            message: Lorem.Ipsum[.sentences(4)]
        )
    }
}

extension Identified where T == Tweet {
    static func random(user: Identified<User>? = nil) -> Identified<Tweet> {
        let tweet = Tweet.random(user: user)
        let id = [tweet.timestamp.description, tweet.message, tweet.user.identifier.rawValue].joined()
        
        return .init(
            identifier: .init(rawValue: id.data(using: .utf8)!.base64EncodedString()),
            value: tweet
        )
    }
}
extension Array where Element == Tweet {
    static func random(count: Int = 15) -> [Tweet] {
        return (1...count).map { _ in Tweet.random() }
    }
}
extension Array where Element == Identified<Tweet> {
    static func random(count: Int = 15, user: Identified<User>? = nil) -> [Identified<Tweet>] {
        return (1...count).map { _ in Identified<Tweet>.random(user: user) }
    }
}

// MARK: - Data

extension Date {
    private static let start = Date().addingTimeInterval(-(60 * 60 * 24 * 7))
    
    static func random() -> Date {
        let interval = TimeInterval.random(in: start.timeIntervalSince1970...Date().timeIntervalSince1970)
        return Date(timeIntervalSince1970: interval)
    }
}

// MARK: - API Responses

extension Authentication {
    static func random() -> Authentication {
        return Authentication(
            token: UUID().uuidString,
            user: .random()
        )
    }
}

extension TweetListOperation.Response {
    static func random(startingWith newTweet: Identified<Tweet>?) -> TweetListOperation.Response {
        if let newTweet = newTweet {
            return .init(tweets: [newTweet] + .random())
        } else {
            return .init(tweets: .random())
        }
    }
}

extension TweetRepliesOperation.Response {
    static func random() -> TweetListOperation.Response {
        return .init(tweets: .random())
    }
}

extension UserTweetsOperation.Response {
    static func random(user: Identified<User>) -> UserTweetsOperation.Response {
        return .init(tweets: .random(user: user))
    }
}
