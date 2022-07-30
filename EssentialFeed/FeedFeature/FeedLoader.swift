//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 30/07/22.
//

import Foundation


protocol FeedLoader {
    func load() async throws -> [FeedItem]
}
