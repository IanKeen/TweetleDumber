//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class TweetTableViewCell: UITableViewCell, NibReusable, Configurable {
    // MARK: - IBOutlets
    @IBOutlet private(set) var avatar: UIImageView!
    @IBOutlet private(set) var name: UILabel!
    @IBOutlet private(set) var when: UILabel!
    @IBOutlet private(set) var message: UILabel!
    
    // MARK: - Private Properties
    private var imageOperation: Cancellable?
    
    // MARK: - Public Functions
    func configure(with object: TweetViewModel) {
        imageOperation?.cancel()
        imageOperation = avatar.setImage(from: URL(object.avatar), placeholder: #imageLiteral(resourceName: "placeholder"))
        
        name.text = object.name
        when.text = object.when
        message.text = object.message
    }
}
