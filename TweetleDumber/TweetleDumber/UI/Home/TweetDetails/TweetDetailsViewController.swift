//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

class TweetDetailsViewController: CustomViewController<UITableView> {
    typealias VM = ViewModel<TweetDetailsViewModelInputs, TweetDetailsViewModelOutputs>
    
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
        title = "Tweet Details"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.refreshControl = UIRefreshControl()
        customView.tableFooterView = UIView()
        
        bindViewModel()
        
        customView.refreshControl!.beginRefreshing(sendEvent: true)
    }
    
    // MARK: - Private Functions
    private func bindViewModel() {
        cancellables.append(
            customView.refreshControl!.bindings.refreshed >> viewModel.input.reload,

            customView.refreshControl!.bindings.refreshing << viewModel.output.working,
            errorResponder << viewModel.output.errors,
            tweetSelectedResponder << viewModel.output.selected,
            customView.bindings.tableSections << viewModel.output.updated.map { tweet, replies in
                return [
                    AnyTableSectionModel(items: [tweet]),
                    AnyTableSectionModel(
                        header: "Replies",
                        items: replies
                    )
                ]
            }
        )
    }
}
