//
//  LocalFeedItem.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 12/09/22.
//

import Foundation

public struct LocalFeedItem: Equatable, Codable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
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
