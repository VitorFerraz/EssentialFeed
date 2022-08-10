//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 30/07/22.
//

import Foundation

public struct FeedItem: Equatable, Codable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case location
        case imageURL = "image"
    }
    
    public init(
        id: UUID,
        description: String? = nil,
        location: String? = nil,
        imageURL: URL
    ) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
    
    
}

public struct FeedItemList: Decodable {
    let items: [FeedItem]
    public init(items: [FeedItem]) {
        self.items = items
    }
}
