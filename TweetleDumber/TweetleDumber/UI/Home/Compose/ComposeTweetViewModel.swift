//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

protocol ComposeTweetViewModelInputs {
    var message: Input<String> { get }
    var tweet: Input<Void> { get }
}

protocol ComposeTweetViewModelOutputs {
    var working: Output<Bool> { get }
    var errors: Output<Error> { get }
    
    var allowTweet: Output<Bool> { get }
    var tweeted: Output<Identified<Tweet>> { get }
    
    var tweetMaxLength: Int { get }
}

class ComposeTweetViewModel: ComposeTweetViewModelInputs, ComposeTweetViewModelOutputs {
    // MARK: - Inputs
    let message: Input<String>
    let tweet: Input<Void>
    
    // MARK: - Outputs
    let tweetMaxLength = 280
    let working: Output<Bool>
    let errors: Output<Error>
    let allowTweet: Output<Bool>
    let tweeted: Output<Identified<Tweet>>
    
    // MARK: - Lifecycle
    init(user: Identified<User>, dateFactory: @escaping () -> Date, apiClient: APIClient) {
        let tracker = OutputTracker()
        let errors = Output<Error>.create()
        let message = Output<String>.create()
        let tweet = Output<Void>.create()
        
        let pendingTweet = message.output.map { Tweet(user: user, timestamp: dateFactory(), message: $0) }
        
        self.allowTweet = pendingTweet
            .validated(by: .tweet(maxLength: tweetMaxLength))
            .startsWith(false)
        
        self.tweeted = tweet.output
            .withLatestFrom(pendingTweet)
            .filter(with: allowTweet)
            .flatMapLatest { tweet in
                return apiClient
                    .perform(operation: TweetOperation(tweet: tweet))
                    .track(with: tracker)
                    .success(emitErrorsTo: errors.input)
            }
        
        self.tweet = tweet.input
        self.message = message.input
        self.errors = errors.output
        self.working = tracker.output
    }
}
