//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 07/09/22.
//

import XCTest

final class LocalFeedLoader {
    init(store: FeedStore) {
      
    }
}

final class FeedStore {
    var deleteCachedFeedCallCount = 0
}

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDelegateCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
}
