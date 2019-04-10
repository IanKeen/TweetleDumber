//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

extension Foundation.Notification.Name {
    static var blockingActivityWindowWillShow: Foundation.Notification.Name {
        return .init(rawValue: #function)
    }
    static var blockingActivityWindowDidHide: Foundation.Notification.Name {
        return .init(rawValue: #function)
    }
}

class BlockingActivityWindow: UIWindow {
    private static var counter = 0
    private static let shared = BlockingActivityWindow()
    
    // MARK: - Lifecycle
    private init() {
        super.init(frame: UIScreen.main.bounds)
        windowLevel = .statusBar + 1
        rootViewController = CustomViewController<BlockingActivityView>()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Functions
    static func show() {
        counter += 1
        
        if counter == 1 {
            shared.rootViewController?.view.alpha = 0
            shared.isHidden = false
            NotificationCenter.default.post(name: .blockingActivityWindowWillShow, object: shared)
            
            UIView.animate(
                withDuration: 0.25, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut],
                animations: {
                    shared.rootViewController?.view.alpha = 1
                },
                completion: nil
            )
        }
    }
    static func hide() {
        counter = max(counter - 1, 0)
        
        if counter == 0 {
            UIView.animate(
                withDuration: 0.25, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut],
                animations: {
                    shared.rootViewController?.view.alpha = 0
                },
                completion: { _ in
                    shared.isHidden = true
                    NotificationCenter.default.post(name: .blockingActivityWindowDidHide, object: shared)
                }
            )
        }
    }
}

class BlockingActivityView: UIView {
    // MARK: - Private Properties
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.hidesWhenStopped = false
        spinner.startAnimating()
        return spinner
    }()
    
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
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(spinner)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        spinner.center = center
    }
}
