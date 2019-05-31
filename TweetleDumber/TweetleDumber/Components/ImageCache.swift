//
//  TweetleDumber
//
//  Created by Ian Keen.
//  Copyright © 2019 Mustard. All rights reserved.
//

import UIKit
import MustardKit

extension UIImageView {
    @discardableResult
    func setImage(from url: URL, placeholder: UIImage?, using imageCache: ImageCache = DefaultImageCache.shared) -> Cancellable {
        self.image = placeholder
        
        return imageCache.getImage(
            from: url,
            deliverOn: DispatchQueue.main,
            complete: { [weak self] result in
                switch result {
                case .success(let image):
                    self?.image = image
                case .failure(let error):
                    print(error)
                }
            }
        )
    }
}

enum ImageCacheError: Error {
    case downloadError
}

protocol ImageCache {
    func getImage(from url: URL, deliverOn context: ExecutionContext, complete: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable
}

class DefaultImageCache: ImageCache {
    static let shared = DefaultImageCache()
    
    private let cache = Atomic<[String: UIImage]>([:])
    
    private init() { }
    
    func getImage(from url: URL, deliverOn context: ExecutionContext, complete: @escaping (Result<UIImage, Error>) -> Void) -> Cancellable {
        if let existing = cache.value[url.absoluteString] {
            context.execute { complete(.success(existing)) }
            return Cancellables.noop()
            
        } else {
            let operation = DispatchWorkItem { [weak self] in
                guard let self = self else { return }
                
                guard
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data)
                    else { return context.execute { complete(.failure(ImageCacheError.downloadError)) } }
                
                self.cache.updating { $0[url.absoluteString] = image }
                context.execute { complete(.success(image)) }
            }
            
            DispatchQueue.global().async(execute: operation)
            return Cancellables.create(operation.cancel)
        }
    }
}
