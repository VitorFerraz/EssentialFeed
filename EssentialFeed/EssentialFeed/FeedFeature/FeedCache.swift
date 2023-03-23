//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 04/12/22.
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
