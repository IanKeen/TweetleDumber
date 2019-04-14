//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class TableView: UITableView {
    var contentOffsetChanged: ((CGPoint) -> Void)?
    
    override var contentOffset: CGPoint {
        didSet { contentOffsetChanged?(contentOffset) }
    }
}

class TweetListView: UIView {
    // MARK: - Elements
    let composeButton = ComposeButton()
    let tableView = TableView()
    
    // MARK: - Private Properties
    private var debounceSetComposeHidden: ((Bool) -> Void)!
    private var visibleConstraint: NSLayoutConstraint!
    private var hiddenConstraint: NSLayoutConstraint!

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
        let function = debounce(delay: 0.35, queue: .main, function: setComposeHidden)
        debounceSetComposeHidden = function
        
        configureTableView()
        configureComposeButton()
        
        enableComposeButton()
    }
    private func configureComposeButton() {
        composeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(composeButton)
        
        visibleConstraint = composeButton.bottomAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.bottomAnchor, constant: -10)
        hiddenConstraint = composeButton.topAnchor.constraint(equalTo: bottomAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            composeButton.heightAnchor.constraint(equalToConstant: 60),
            composeButton.widthAnchor.constraint(equalToConstant: 60),
            composeButton.rightAnchor.constraint(equalTo: compatibleSafeAreaLayoutGuide.rightAnchor, constant: -10),
            hiddenConstraint
        ])
    }
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Compose Button
    private func enableComposeButton() {
        tableView.contentOffsetChanged = { [unowned self] point in
            let hide = point.y > 0
            if hide {
                self.setComposeHidden(true)
                self.debounceSetComposeHidden(false)
            } else {
                self.setComposeHidden(false)
            }
        }
    }
    private func setComposeHidden(_ hidden: Bool) {
        layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.3, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut],
            animations: {
                // This was made a little more verbose because the disable has to
                // come before the enable to avoid autolayout errors in the console.
                // Visually it doesn't matter, the console output just bugs me.
                if hidden {
                    self.visibleConstraint.isActive = false
                    self.hiddenConstraint.isActive = true
                } else {
                    self.hiddenConstraint.isActive = false
                    self.visibleConstraint.isActive = true
                }
                self.layoutIfNeeded()
            },
            completion: nil
        )
    }
}
