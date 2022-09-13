//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 09/09/22.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    func deleteCachedFeed(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem], currentDate: Date, completion: @escaping InsertionCompletion)
}

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
