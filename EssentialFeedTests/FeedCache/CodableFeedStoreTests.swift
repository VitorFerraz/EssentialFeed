//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 25/09/22.
//

import XCTest
import EssentialFeed



final class CodableFeedStoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_retrive_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrive: .empty)
    }
    
    func test_retrive_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrive_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        expect(sut, toRetrive: .found(feed: feed, timestamp: timestamp))
    }
    
    func test_retrive_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        expect(sut, toRetrieveTwice: .found(feed: feed, timestamp: timestamp))

    }
    
    func test_retrive_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrive: .failure(anyNSError))
    }
    
    func test_retrive_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        expect(sut, toRetrieveTwice: .failure(anyNSError))
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let firstInsertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        let latestInsertionError = insert((latestFeed, latestTimestamp), to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to insert cache successfully")
        expect(sut, toRetrive: .found(feed: latestFeed, timestamp: latestTimestamp))
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "expected cache insertion to fail with an error")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        
        insert((uniqueImageFeed().local, Date()), to: sut)
        
        let deletionError = deleteCache(from: sut)
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        
        expect(sut, toRetrive: .empty)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let nonDeletePermissionURL = invalidCacheDirectory()
        let sut = makeSUT(storeURL: nonDeletePermissionURL)
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
        expect(sut, toRetrive: .empty)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "operation 1")
        sut.insert(uniqueImageFeed().local, currentDate: Date()) { _ in
            op1.fulfill()
            completedOperationsInOrder.append(op1)
        }
        
        let op2 = expectation(description: "operation 2")
        sut.deleteCachedFeed(completion: { _ in
            op2.fulfill()
            completedOperationsInOrder.append(op2)
        })
        
        let op3 = expectation(description: "operation 3")
        sut.insert(uniqueImageFeed().local, currentDate: Date()) { _ in
            op3.fulfill()
            completedOperationsInOrder.append(op3)
        }
        
        waitForExpectations(timeout: 5)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the worn order")
        
    }

    
    //MARK: - Helpers
    
    @discardableResult
    private func deleteCache(from sut: FeedStore) -> Error? {
        let exp = expectation(description: "wait for cache deletion")
        var deletionError: Error?
        
        sut.deleteCachedFeed { error in
            deletionError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        return deletionError
    }
    
    @discardableResult
    private func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        let exp = expectation(description: "wait for cache insertion")
        var insertionError: Error?
        
        sut.insert(cache.feed, currentDate: cache.timestamp) { error in
            insertionError = error
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        return insertionError
    }
    
    private func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: RetrievedCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrive: expectedResult)
        expect(sut, toRetrive: expectedResult)
    }
    
    private func expect(_ sut: FeedStore, toRetrive expectedResult: RetrievedCachedFeedResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for cache retrival")
        
        sut.retrieve { retrivedResult in
            switch (expectedResult, retrivedResult) {
            case (.empty, .empty),
                 
                (.failure, .failure):
                break
            case let (.found(firstFound), .found(secondFound)):
                XCTAssertEqual(firstFound.feed, secondFound.feed, file: file, line: line)
                XCTAssertEqual(firstFound.timestamp, secondFound.timestamp, file: file, line: line)
            default:
                XCTFail("Expected to retrived \(expectedResult), got \(retrivedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #file, line: UInt = #line) -> FeedStore {
        let storeURL = storeURL ?? testSpecificStoreURL()
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func deleteStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    func setupEmptyStoreState() {
        deleteStoreArtifacts()
    }
    
    func undoStoreSideEffects() {
        deleteStoreArtifacts()
    }
    
    func testSpecificStoreURL() -> URL {
        cachesDirectory()
        .appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
    
    private func invalidCacheDirectory() -> URL {
        FileManager.default.urls(for: .adminApplicationDirectory, in: .systemDomainMask).first!
    }
}
