//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 11/08/22.
//

import Foundation
import EssentialFeed

struct FeedItemsMapper {
    private struct Root: Codable {
        private let items: [RemoteFeedItem]
        
        var images: [FeedImage] {
            items.map {
                FeedImage(
                    id: $0.id,
                    description: $0.description,
                    location: $0.location,
                    url: $0.image
                )
            }
        }
        
        private struct RemoteFeedItem: Equatable, Codable {
            let id: UUID
            let description: String?
            let location: String?
            let image: URL
        }
    }
    
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return root.images
    }
}
