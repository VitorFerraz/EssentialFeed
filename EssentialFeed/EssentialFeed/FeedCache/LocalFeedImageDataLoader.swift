//
//  LocalFeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 06/11/22.
//

import Foundation

public final class LocalFeedImageDataLoader: FeedImageDataCache {
    private let store: FeedImageDataStore

    public init(store: FeedImageDataStore) {
        self.store = store
    }
}

public extension LocalFeedImageDataLoader {
    enum SaveError: Error {
        case failed
    }

    func save(_ data: Data, for url: URL) throws {
        do {
            try store.insert(data, for: url)
        }
        catch { throw SaveError.failed }
    }
}

extension LocalFeedImageDataLoader: FeedImageDataLoader {

    public enum LoadError: Error {
        case failed
        case notFound
    }

    public func loadImageData(from url: URL) throws -> Data {
        do {
            if let imageData = try store.retrieve(dataForURL: url) {
                return imageData
            }
        } catch {
            throw LoadError.failed
        }
        
        throw LoadError.notFound
    }
}
