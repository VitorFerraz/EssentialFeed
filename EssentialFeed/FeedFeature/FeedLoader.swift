//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 30/07/22.
//

import Foundation


public typealias LoadFeedResult<Failure: Error> = Result<[FeedItem], Failure>

protocol FeedLoader {
    associatedtype Error: Swift.Error
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void)
}
