//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

class ComposeTweetViewController: UIViewController {
    typealias VM = ViewModel<ComposeTweetViewModelInputs, ComposeTweetViewModelOutputs>
    
    // MARK: - IBOutlets
    @IBOutlet private var message: TextView!
    private let characterCount = UILabel()
    
    // MARK: - Private Properties
    private let viewModel: VM
    private let cancellables = CancellableBag()

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
        
        configureInputFields()
        configureCharacterCount()
        configureSubmit()
        
        bindViewModel()
        
        message.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        message.resignFirstResponder()
    }
    
    // MARK: - Private Properties
    private func bindViewModel() {
        cancellables.append(
            navigationItem.rightBarButtonItem!.bindings.isEnabled << viewModel.output.allowTweet,
            errorResponder << viewModel.output.errors,
            workingResponder << viewModel.output.working,
            tweetCompleteResponder << viewModel.output.tweeted,
            
            message.bindings.text >> viewModel.input.message,
            navigationItem.rightBarButtonItem!.bindings.tap >> viewModel.input.tweet
        )
    }
    private func configureSubmit() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tweet", style: .plain, target: nil, action: nil)
    }
    private func configureCharacterCount() {
        guard let toolbar = message.inputAccessoryView as? UIToolbar else { return }
        
        toolbar.items?.insert(UIBarButtonItem(customView: characterCount), at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageUpdated), name: UITextView.textDidChangeNotification, object: message)
        messageUpdated()
    }
    @objc private func messageUpdated() {
        let count = message.text.count
        characterCount.text = "\(count) / \(viewModel.output.tweetMaxLength)"
        characterCount.sizeToFit()
        characterCount.textColor = (count <= viewModel.output.tweetMaxLength) ? .black : .red
    }
}
