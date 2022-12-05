//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 30/07/22.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (FeedLoader.Result) -> Void)
}
