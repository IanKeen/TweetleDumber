//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class ProfileViewController: CustomViewController<UITableView> {
    typealias VM = ViewModel<ProfileViewModelInputs, ProfileViewModelOutputs>
    
    // MARK: - Private Properties
    private let viewModel: VM
    private let cancellables = CancellableBag()
    private let userView = UserView()
    
    // MARK: - Lifecycle
    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            userView.bindings.configure << viewModel.output.user,
            customView.bindings.tableSections << viewModel.output.updated.map { [unowned self] tweets in
                return [
                    AnyTableSectionModel(header: .view(self.userView), items: []),
                    AnyTableSectionModel(header: "Tweets", items: tweets)
                ]
            }
        )
    }
}
