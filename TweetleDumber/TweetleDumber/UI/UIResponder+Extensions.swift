//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

extension UIResponder {
    @objc func handleError(_ error: Error) {
        next?.handleError(error)
    }
}

extension UIResponder {
    var errorResponder: Input<Error> {
        return .init { error in
            self.handleError(error)
        }
    }
}

extension UIResponder {
    var workingResponder: Input<Bool> {
        return .init { value in
            switch value {
            case true: BlockingActivityWindow.show()
            case false: BlockingActivityWindow.hide()
            }
        }
    }
}

extension UIResponder {
    var tweetSelectedResponder: Input<Identified<Tweet>> {
        return .init { self.tweetSelected(ResponderBox($0)) }
    }
    @objc func tweetSelected(_ tweet: ResponderBox) {
        next?.tweetSelected(tweet)
    }
}

extension UIResponder {
    @objc func composeTweet() {
        next?.composeTweet()
    }
}

extension UIResponder {
    var tweetCompleteResponder: Input<Identified<Tweet>> {
        return .init { self.tweetCompleted(ResponderBox($0)) }
    }
    
    @objc func tweetCompleted(_ tweet: ResponderBox) {
        next?.tweetCompleted(tweet)
    }
}
