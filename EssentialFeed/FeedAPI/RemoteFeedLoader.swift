//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 05/08/22.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient
    public typealias Result = LoadFeedResult<Error>
    
    public enum Error: Swift.Error, Equatable {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (LoadFeedResult<RemoteFeedLoader.Error>) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success((let data, let response)):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
