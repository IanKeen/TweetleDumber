//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import MustardKit

struct APIError: LocalizedError, Decodable {
    let message: String
    
    var errorDescription: String? { return message }
}

class APIErrorBehaviour: APIBehaviour {
    func apiClient<T: APIOperation>(_ apiClient: APIClient, operationReceived operation: T, request: HTTPRequest, response: Result<HTTPResponse, Error>, next: @escaping (Result<HTTPResponse, Error>) -> Void) {
        next(response.throwingMap({ response in
            if let error = response.data.flatMap({ try? APIClient.defaultJSONDecoder.decode(APIError.self, from: $0) }) {
                throw error
            } else {
                return response
            }
        }))
    }
}
