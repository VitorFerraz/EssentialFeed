//
//  RemoteLoader.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 29/12/22.
//

import Foundation
import EssentialFeed

public final class RemoteLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    public typealias Result = FeedLoader.Result
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success((let data, let response)):
                completion(RemoteLoader.map(data, response))
            case .failure:
                completion(.failure(RemoteLoader.Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, _ response: HTTPURLResponse) -> Result {
        do {
            let items = try FeedItemsMapper.map(data, from: response)
            return .success(items)
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
