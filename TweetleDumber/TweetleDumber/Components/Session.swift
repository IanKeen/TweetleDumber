//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import Foundation
import MustardKit

class Session {
    // MARK: - Private Properties
    private let dataStore: DataStore
    private let stateMachine: ApplicationStateMachine
    private let apiClient: APIClient
    
    // MARK: - Lifecycle
    init(stateMachine: ApplicationStateMachine, apiClient: APIClient, dataStore: DataStore) {
        self.stateMachine = stateMachine
        self.apiClient = apiClient
        self.dataStore = dataStore
    }
    
    // MARK: - Public Functions
    func signIn(username: String, password: String, complete: @escaping (Result<Void>) -> Void) -> Cancellable {
        let signIn = SignInOperation(username: username, password: password)
        return performAuth(signIn, complete: complete)
    }
    func signUp(username: String, password: String, complete: @escaping (Result<Void>) -> Void) -> Cancellable {
        let signUp = SignUpOperation(username: username, password: password)
        return performAuth(signUp, complete: complete)
    }
    func signOut() {
        dataStore.removeAll(Authentication.self)
        stateMachine.transition(with: .signOut)
    }
    func restoreSession() {
        switch dataStore.item(Authentication.self) {
        case let auth?:
            stateMachine.transition(with: .signIn(auth))
        case nil:
            stateMachine.transition(with: .signOut)
        }
    }
    
    // MARK: - Private Functions
    private func performAuth<T: APIOperation>(_ operation: T, complete: @escaping (Result<Void>) -> Void) -> Cancellable where T.Response == Authentication {
        return apiClient.perform(operation: operation) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.dataStore.upsert(value)
                self.stateMachine.transition(with: .signIn(value))
                complete(.success(()))
                
            case .failure(let error):
                complete(.failure(error))
            }
        }
    }
}

extension Session: Bindable { }

extension Bindings where Base == Session {
    func signIn(username: String, password: String) -> Output<Result<Void>> {
        return .init { input in
            let task = self.base.signIn(username: username, password: password, complete: input.send)
            return Cancellables.create(task.cancel)
        }
    }
    func signUp(username: String, password: String) -> Output<Result<Void>> {
        return .init { input in
            let task = self.base.signUp(username: username, password: password, complete: input.send)
            return Cancellables.create(task.cancel)
        }
    }
}
