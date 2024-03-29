//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 06/11/22.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
