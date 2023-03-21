//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 06/11/22.
//

import Foundation

public final class LocalFeedImageDataLoader: FeedImageCache {
    private let store: FeedImageDataStore

    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

public extension LocalFeedImageDataLoader {
    typealias SaveResult = Result<Void, Error>

    enum SaveError: Error {
        case failed
    }

    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
        completion(SaveResult {
            try store.insert(data, for: url)
        })
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {
    public typealias LoadResult = FeedImageDataLoader.Result

    public enum LoadError: Error {
        case failed
        case notFound
    }

    private final class LoadImageDataTask: FeedImageDataLoaderTask {
        private var completion: ((FeedImageDataLoader.Result) -> Void)?

        init(_ completion: @escaping (FeedImageDataLoader.Result) -> Void) {
            self.completion = completion
        }

        func complete(with result: FeedImageDataLoader.Result) {
            completion?(result)
        }

        func cancel() {
            preventFurtherCompletions()
        }

        private func preventFurtherCompletions() {
            completion = nil
        }
    }

    public func loadImageData(from url: URL, completion: @escaping (LoadResult) -> Void) -> FeedImageDataLoaderTask {
        let task = LoadImageDataTask(completion)
        task.complete(with: Swift.Result {
            try store.retrieve(dataForURL: url)
        }
            .mapError { _ in LoadError.failed }
            .flatMap { data in
                data.map { .success($0) } ?? .failure(LoadError.notFound)
            })
        return task
    }
}
