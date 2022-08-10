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
            case .success((let data, let response)):
                if let root = try? JSONDecoder().decode(Root.self, from: data), response.statusCode == 200 {
                    completion(.success(root.items.map{ $0.item }))
                } else {
                    completion(.failure(.invalidData))
                }
            case .failure:
                completion(.failure(.connectivity))
            }
        }
    }
}

private struct Root: Codable {
    let items: [Item]
}

private struct Item: Equatable, Codable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
    
    var item: FeedItem {
        FeedItem(
            id: id,
            description: description,
            location: location,
            imageURL: imageURL
        )
    }
}

extension Item {
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case imageURL = "image"
    }
}
