//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    @IBOutlet private(set) var username: UITextField!
    @IBOutlet private(set) var password: UITextField!
    @IBOutlet private(set) var passwordConfirmation: UITextField!
    @IBOutlet private(set) var signUp: UIButton!

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var scrollViewBottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        configureInputFields()
        scrollView.keyboardConstraint = scrollViewBottomConstraint
    }
}
