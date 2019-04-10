//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class TweetListViewController: CustomViewController<TweetListView> {
    typealias VM = ViewModel<TweetListViewModelInputs, TweetListViewModelOutputs>
    
    // MARK: - Private Properties
    private let viewModel: VM
    private let cancellables = CancellableBag()
    
    // MARK: - Lifecycle
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        title = "Tweets"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.composeButton.addTarget(for: .touchUpInside) { [unowned self] _ in
            self.composeTweet()
        }
        
        bindViewModel()
        
        customView.tableView.refreshControl!.beginRefreshing(sendEvent: true)
    }

    // MARK: - Private Functions
    private func bindViewModel() {
        cancellables.append(
            customView.tableView.refreshControl!.bindings.refreshed >> viewModel.input.reload,

            customView.tableView.refreshControl!.bindings.refreshing << viewModel.output.working,
            customView.tableView.bindings.tableItems << viewModel.output.updated,
            tweetSelectedResponder << viewModel.output.selected,
            errorResponder << viewModel.output.errors
        )
    }
    
    // MARK: - UIResponder
    override func tweetCompleted(_ tweet: ResponderBox) {
        viewModel.input.reload.send(())
    }
}
