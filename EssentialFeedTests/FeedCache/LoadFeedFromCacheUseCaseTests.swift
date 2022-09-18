//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 13/09/22.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrival() {
        let (sut, store) = makeSUT()

        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrivelError() {
        let (sut, store) = makeSUT()
        let expectedError = anyNSError
        expect(sut, toCompleteWith: .failure(expectedError)) {
            store.completeRetrieval(with: expectedError)
        }
    }
    
    func test_load_deliversNoImageOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalWithEmptyCache()
        }
    }
    
    func test_load_deliversCachedImagesOnNonExperiedCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds : 1)
        let feed = uniqueImageFeed()
        expect(sut, toCompleteWith: .success(feed.models)) {
            store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnCacheExpiration() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let expirationTimestamp = fixedCurrentData.minusFeedCacheMaxAge()
        let feed = uniqueImageFeed()
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnExpiredCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let expiredTimestamp = fixedCurrentData.minusFeedCacheMaxAge().adding(seconds: -1)
        let feed = uniqueImageFeed()
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp )
        }
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectOnNonExpiredCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let nonExpiredTimestamp = fixedCurrentData.minusFeedCacheMaxAge().adding(days: 1)
        let feed = uniqueImageFeed()
        
        sut.load { _ in }

        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp )
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnExpirationCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let expirationTimestamp = fixedCurrentData.minusFeedCacheMaxAge()
        let feed = uniqueImageFeed()
        
        sut.load { _ in }
        
        store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp )
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsExpiredCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let expiredTimestamp = fixedCurrentData.minusFeedCacheMaxAge() .adding(days: -1)
        let feed = uniqueImageFeed()
        
        sut.load { _ in }
        
        store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp )
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_doesNotDeliversResultAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        var receivedResults = [LocalFeedLoader.LoadResult]()
        
        sut?.load(completion: { result in
            receivedResults.append(result)
        })
        
        sut = nil
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    //MARK: - Helpers
    
    private func expect(
        _ sut: LocalFeedLoader,
        toCompleteWith expectedResult: LocalFeedLoader.LoadResult,
        with action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "wait for load complete")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedImages), .success(expectedImages)):
                XCTAssertEqual(receivedImages, expectedImages, file: file, line: line)
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
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

