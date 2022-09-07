//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 07/09/22.
//

import XCTest
import EssentialFeed

final class LocalFeedLoader {
    private let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCachedFeed()
    }
}

final class FeedStore {
    var deleteCachedFeedCallCount = 0
    var insertCallCount = 0
    
    func deleteCachedFeed() {
        deleteCachedFeedCallCount += 1
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        
    }
}

final class CacheFeedUseCaseTests: XCTestCase {

    func test_init_doesNotDelegateCacheUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.deleteCachedFeedCallCount, 0)
    }
    
    func test_save_requestCacheDeletion() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]

        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedFeedCallCount, 1)
    }
    
    func test_save_doesNotRequestCacheInsertionOnDelegetionError() {
        let (sut, store) = makeSUT()
        let items = [uniqueItem(), uniqueItem()]
        let deletionError = anyNSError
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    
    // MARK: - Helpers
    private var anyNSError: NSError {
        NSError(domain: "", code: 1)
    }
    
    private func uniqueItem() -> FeedItem {
        FeedItem(id: UUID(), imageURL: anyURL)
    }
    
    private var anyURL: URL {
        URL(string: "http://any-url.com")!
    }
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}
