//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

protocol TweetListViewModelInputs {
    var reload: Input<Void> { get }
}

protocol TweetListViewModelOutputs {
    var working: Output<Bool> { get }
    var errors: Output<Error> { get }
    
    var updated: Output<[AnyTableCellModel]> { get }
    var selected: Output<Identified<Tweet>> { get }
}

class TweetListViewModel: TweetListViewModelInputs, TweetListViewModelOutputs {
    // MARK: - Inputs
    let reload: Input<Void>
    
    // MARK: - Outputs
    let selected: Output<Identified<Tweet>>
    let updated: Output<[AnyTableCellModel]>
    let working: Output<Bool>
    let errors: Output<Error>
    
    // MARK: - Lifecycle
    init(apiClient: APIClient, formatter: FormatterProvider) {
        let tracker = OutputTracker()
        let errors = Output<Error>.create()
        let reload = Output<Void>.create()
        let selected = Output<Identified<Tweet>>.create()
        
        self.updated = reload.output.flatMapLatest {
            return apiClient
                .perform(operation: TweetListOperation())
                .track(with: tracker)
                .success(emitErrorsTo: errors.input)
                .map { response in
                    return response.tweets.sorted(by: ^\.value.timestamp).map { tweet in
                        return TweetViewModel(tweet: tweet, formatter: formatter, selection: selected.input.map { tweet })
                    }
                }
        }
        
        self.selected = selected.output
        self.working = tracker.output
        self.errors = errors.output
        self.reload = reload.input
    }
}
