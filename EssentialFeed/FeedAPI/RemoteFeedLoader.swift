//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 05/08/22.
//

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}


public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient
    public typealias Result = Swift.Result<[FeedItem], RemoteFeedLoader.Error>

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .success((let data, _)):
                if let feedItemList = try? JSONDecoder().decode(FeedItemList.self, from: data) {
                    completion(.success(feedItemList.items))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}
