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
