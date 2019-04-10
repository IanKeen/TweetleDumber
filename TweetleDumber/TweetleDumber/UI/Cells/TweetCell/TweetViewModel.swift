//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

class TweetViewModel: SelectionAware {
    // MARK: - Public Properties
    let avatar: String
    let name: String
    let when: String?
    let message: String
    let canSelect: Bool
    
    // MARK: - Private Properties
    private let selection: Input<Void>
    
    // MARK: - Lifecycle
    init(tweet: Identified<Tweet>, formatter: FormatterProvider, canSelect: Bool = true, selection: Input<Void>) {
        self.avatar = tweet.value.user.value.avatar
        self.name = tweet.value.user.value.name
        self.when = formatter.format(with: .tweetDate, input: tweet.value.timestamp).map({ "\($0) ago." })
        self.message = tweet.value.message
        self.selection = selection
        self.canSelect = canSelect
    }
    func selected(value: Bool, indexPath: IndexPath, undo: @escaping () -> Void) {
        guard value else { return }
        
        selection.send(())
    }
}

extension MustardKit.Formatter {
    public static var tweetDate: MustardKit.Formatter<Date> {
        return .init(key: #function, factory: {
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 2
            return { formatter.string(from: $0, to: Date()) }
        })
    }
}

extension TweetViewModel: TableCellModel {
    typealias TableCell = TweetTableViewCell
}
