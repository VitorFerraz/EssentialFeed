//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 10/12/22.
//

import Foundation
public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
