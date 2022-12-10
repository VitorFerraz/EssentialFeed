//
//  FeedImageCache.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 10/12/22.
//

import Foundation
public protocol FeedImageCache {
    typealias SaveResult = Result<Void, Error>
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
