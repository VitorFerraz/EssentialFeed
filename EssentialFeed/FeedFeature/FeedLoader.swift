//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 30/07/22.
//

import Foundation


public typealias LoadFeedResult = Result<[FeedItem], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
