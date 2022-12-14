//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Vitor Ferraz Varela on 04/12/22.
//

import Foundation
import EssentialFeed

final class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
