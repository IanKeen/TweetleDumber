//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

protocol TweetDetailsViewModelInputs {
    var reload: Input<Void> { get }
}

protocol TweetDetailsViewModelOutputs {
    typealias Dataset = (tweet: AnyTableCellModel, replies: [AnyTableCellModel])
    
    var working: Output<Bool> { get }
    var errors: Output<Error> { get }
    
    var updated: Output<Dataset> { get }
    var selected: Output<Identified<Tweet>> { get }
}

class TweetDetailsViewModel: TweetDetailsViewModelInputs, TweetDetailsViewModelOutputs {
    // MARK: - Inputs
    let reload: Input<Void>
    
    // MARK: - Outputs
    let selected: Output<Identified<Tweet>>
    let updated: Output<Dataset>
    let working: Output<Bool>
    let errors: Output<Error>
    
    // MARK: - Lifecycle
    init(tweet: Identified<Tweet>, apiClient: APIClient, formatter: FormatterProvider) {
        let tracker = OutputTracker()
        let errors = Output<Error>.create()
        let reload = Output<Void>.create()
        let selected = Output<Identified<Tweet>>.create()
        
        let tweetVM = TweetViewModel(tweet: tweet, formatter: formatter, canSelect: false, selection: .never())
        
        self.updated = reload.output
            .flatMapLatest {
                return apiClient
                    .perform(operation: TweetRepliesOperation(id: tweet.identifier))
                    .track(with: tracker)
                    .success(emitErrorsTo: errors.input)
                    .map { response in
                        let replyVMs = response.tweets.sorted(by: ^\.value.timestamp).map { tweet in
                            return TweetViewModel(tweet: tweet, formatter: formatter, selection: selected.input.map { tweet })
                        }
                        return (tweetVM, replyVMs)
                }
            }
            .startsWith((tweetVM, []))

        self.selected = selected.output
        self.working = tracker.output
        self.errors = errors.output
        self.reload = reload.input
    }
}
