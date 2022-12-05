//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 04/12/22.
//

import Foundation

public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>
    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
