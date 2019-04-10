//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class UserView: UIView {
    // MARK: - Elements
    private(set) lazy var avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private(set) lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    private(set) lazy var handle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .lightGray
        return label
    }()
    private(set) lazy var bio: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 0
        return label
    }()
    private(set) lazy var following: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    private(set) lazy var followers: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    private func configure() {
        [avatar, name, handle, bio, following, followers].forEach(addSubview)
        
        NSLayoutConstraint.activate([
            avatar.heightAnchor.constraint(equalToConstant: 60),
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            avatar.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            
            name.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            name.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8),
            name.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),

            handle.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            handle.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8),
            handle.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),

            bio.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            bio.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 8),
            bio.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            
            following.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            following.topAnchor.constraint(equalTo: bio.bottomAnchor, constant: 8),

            followers.leftAnchor.constraint(equalTo: following.rightAnchor, constant: 8),
            followers.topAnchor.constraint(equalTo: following.topAnchor),
        ])
    }
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        let views = [avatar, name, handle, bio, following]
        
        let result = views.reduce(CGSize.zero) { value, view in
            let viewSize = view.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: .defaultLow)
            return CGSize(width: targetSize.width, height: value.height + viewSize.height)
        }
        
        return CGSize(width: targetSize.width, height: result.height + CGFloat((views.count + 1) * 8))
    }
}

extension UserView: Bindable { }

extension Bindings where Base: UserView {
    var configure: Input<User> {
        return .init { user in
            self.base.avatar.setImage(from: URL(user.avatar), placeholder: #imageLiteral(resourceName: "placeholder"))
            self.base.name.text = user.name
            self.base.handle.text = user.handle
            self.base.bio.text = user.bio
            self.base.followers.text = "\(user.followers) Followers"
            self.base.following.text = "\(user.following) Following"
        }
    }
}
