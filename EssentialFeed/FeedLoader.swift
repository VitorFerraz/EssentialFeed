//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 30/07/22.
//

import Foundation


typealias LoadFeedResult = Result<[FeedItem], Error>
protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
