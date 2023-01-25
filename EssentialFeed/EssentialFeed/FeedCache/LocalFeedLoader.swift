//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 09/09/22.
//

import Foundation

public final class LocalFeedLoader: FeedCache {
    private let store: FeedStore
    private let currentDate: () -> Date

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public extension LocalFeedLoader {
    typealias SaveResult = FeedCache.Result

    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedFeed { [weak self] deletionResult in
            guard let self = self else { return }
            switch deletionResult {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                self.cache(feed, with: completion)
            }
        }
    }

    private func cache(_ feed: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store.insert(feed.toLocal(), timestamp: currentDate(), completion: { [weak self] insertionResult in
            guard self != nil else { return }
            completion(insertionResult)
        })
    }
}

public extension LocalFeedLoader {
    typealias LoadResult = Swift.Result<[FeedImage], Error>

    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(.some(cachedFeed)) where FeedCachePolicy.validate(cachedFeed.timestamp, agains: self.currentDate()):
                completion(.success(cachedFeed.feed.toModels()))
            case .success:
                completion(.success([]))
            }
        }
    }
}

public extension LocalFeedLoader {
    typealias ValidationResult = Result<Void, Error>

    func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure:
                self.store.deleteCachedFeed(completion: completion)

            case let .success(.some(cache)) where !FeedCachePolicy.validate(cache.timestamp, agains: self.currentDate()):
                self.store.deleteCachedFeed(completion: completion)

            case .success:
                completion(.success(()))
            }
        }
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        map {
            LocalFeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        map {
            FeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
    }
}
