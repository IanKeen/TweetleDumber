//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

class DependenciesApplicationService: NSObject, UIApplicationDelegate {
    override init() {
        super.init()
        
        typealias DateFactory = () -> Date
        
        Dependencies.default
            .register(ApplicationStateMachine.self, strategy: .singleton, instance: { _ in DefaultStateMachine })
            .register(ReadOnlyApplicationStateMachine.self, strategy: .singleton, instance: { try $0.resolve(ApplicationStateMachine.self).readOnly() })
            .register(DataStore.self, strategy: .singleton, instance: { _ in MemoryDataStore().binaryStore(name: "tweetledumber").threadSafe() })
            .register(FormatterProvider.self, strategy: .singleton, instance: { _ in FormatterProvider() })
            .register(DateFactory.self, strategy: .unique, instance: { _ in Date.init })
            .register(Session.self, strategy: .singleton, instance: {
                return try Session(stateMachine: $0.resolve(), apiClient: $0.resolve(), dataStore: $0.resolve())
            })
            .register(APIClient.self, strategy: .singleton, instance: {
                let stateMachine = try $0.resolve(ReadOnlyApplicationStateMachine.self)
                
                let base = BaseURLBehaviour { URL("http://api.twitter.com") }
                
                
                // START MOCK BEHAVIOUR
                var tempNewTweet: Identified<Tweet>?
                let mocks = APIMockBehaviour()
                mocks.mock(.randomRequest, delay: 1, with: APIError(message: "An unexpected error occurred"))
                mocks.mock(.any(SignInOperation.self), delay: 1, with: { Authentication.random() })
                mocks.mock(.any(SignUpOperation.self), delay: 1, with: { Authentication.random() })
                mocks.mock(.any(TweetListOperation.self), delay: 1, with: { TweetListOperation.Response.random(startingWith: tempNewTweet) })
                mocks.mock(.any(TweetRepliesOperation.self), delay: 1, with: { TweetRepliesOperation.Response.random() })
                mocks.mock(.any(TweetOperation.self), delay: 2, with: { req -> Result<HTTPResponse> in
                    return Result.attempt {
                        switch try req.body.encode()?.source {
                        case .data(let data)?:
                            let tweet = try defaultJSONDecoder.decode(Tweet.self, from: data)
                            let newTweet = Identified<Tweet>(
                                identifier: .init(rawValue: UUID().uuidString),
                                value: tweet
                            )
                            tempNewTweet = newTweet
                            let response = try defaultJSONEncoder.encode(newTweet)
                            return HTTPResponse(code: 200, headers: [], data: response)
                            
                        default:
                            throw APIError(message: "Invalid request body")
                        }
                    }
                })
                mocks.mock(.any(UserTweetsOperation.self), delay: 1, with: { () throws -> UserTweetsOperation.Response in
                    switch stateMachine.state {
                    case .signedIn(let auth):
                        return UserTweetsOperation.Response.random(user: auth.user)
                    case .pending, .signedOut:
                        throw APIError(message: "Unexpected state")
                    }
                })
                // END MOCK BEHAVIOUR
                
                
                let auth = BearerSigningBehaviour {
                    switch stateMachine.state {
                    case .signedIn(let auth):
                        return auth.token
                    case .pending, .signedOut:
                        return nil
                    }
                }
                
                return APIClient(http: URLSessionHTTP(), globalBehaviours: [APIErrorBehaviour(), base, auth, mocks])
            })
    }
}

extension APIRequestMatcher {
    static var randomRequest: APIRequestMatcher {
        return .any(where: { _ in Int.random(in: 1...10) > 8 })
    }
}
