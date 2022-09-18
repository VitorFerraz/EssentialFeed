//
//  ValidateFeedCacheUserCaseTests.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 16/09/22.
//

import XCTest
import EssentialFeed

final class ValidateFeedCacheUserCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrieval(with: anyNSError)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteNonExpiredCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let nonExpiredTimestamp = fixedCurrentData.minusFeedCacheMaxAge().adding(seconds: 1)
        let feed = uniqueImageFeed()
        
        sut.validateCache()
        
        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesCacheOnExpiration() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let expirationTimestamp = fixedCurrentData.minusFeedCacheMaxAge()
        let feed = uniqueImageFeed()
        
        sut.validateCache()
        
        store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_deletesCacheOnExpiredCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let expiredTimestamp  = fixedCurrentData.minusFeedCacheMaxAge().adding(seconds: -1)
        let feed = uniqueImageFeed()
        
        sut.validateCache()
        
        store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    func test_validateCache_doesNotDeliversInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
                
        sut?.validateCache()
        
        sut = nil
        store.completeRetrieval(with: anyNSError)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    //MARK: - Helpers

    private func makeSUT(
        currentDate: @escaping () -> Date = { Date() },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}
