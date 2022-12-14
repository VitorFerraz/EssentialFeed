//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 11/08/22.
//

import Foundation

struct FeedItemsMapper {
    private struct Root: Codable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.items
    }
}
