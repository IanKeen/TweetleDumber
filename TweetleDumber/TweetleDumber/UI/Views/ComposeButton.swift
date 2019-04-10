//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class ComposeButton: UIButton {
    // MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        configure()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    private func configure() {
        clipsToBounds = true
        backgroundColor = .blue
        setTitle("+", for: .normal)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.midX
    }
}
