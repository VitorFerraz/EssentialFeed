//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 11/08/22.
//

import Foundation

struct RemoteFeedItem: Equatable, Codable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

struct FeedItemsMapper {
    private struct Root: Codable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.statusCode == OK_200,
             let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
