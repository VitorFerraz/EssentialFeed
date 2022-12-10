//
//  FeedImageDataLoaderDecorator.swift
//  EssentialApp
//
//  Created by Vitor Ferraz Varela on 10/12/22.
//

import Foundation
import EssentialFeed

public final class FeedImageDataLoaderDecorator: FeedImageDataLoader {
    
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) -> EssentialFeed.FeedImageDataLoaderTask {
        decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { feedImage in
                self?.cache.saveIgnoringResult(feedImage, for: url)
                return feedImage
            })
        }
    }
    
}

private extension FeedImageCache {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        save(data, for: url) { _ in }
    }
}
