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
    
    func test_load_deliversCachedImagesOnLessThanSevenDaysOldCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentDate = Date()
        let lessThanSevenDaysOldTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: 1)
        let feed = uniqueImageFeed()
        expect(sut, toCompleteWith: .success(feed.models)) {
            store.completeRetrieval(with: feed.local, timestamp: lessThanSevenDaysOldTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnLessThanSevenDaysOldCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let lassThanSeverDaysOldTimestamp = fixedCurrentData.adding(days: -7)
        let feed = uniqueImageFeed()
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: lassThanSeverDaysOldTimestamp)
        }
    }
    
    func test_load_deliversNoImagesOnMoreThanSevenDaysOldCache() {
        let (sut, store) = makeSUT()
        let fixedCurrentData = Date()
        let moreThanThanSeverDaysOldTimestamp = fixedCurrentData.adding(days: -7).adding(days: -1)
        let feed = uniqueImageFeed()
        expect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: feed.local, timestamp: moreThanThanSeverDaysOldTimestamp)
        }
    }
    
    func test_load_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        store.completeRetrieval(with: anyNSError)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCachedFeed])
    }
    
    //MARK: - Helpers
    
    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let models = [uniqueImage(), uniqueImage()]
        let local = models.map {
            LocalFeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                url: $0.url
            )
        }
        return (models, local)
    }
    
    private func uniqueImage() -> FeedImage {
        FeedImage(id: UUID(), url: anyURL)
    }
    
    private var anyURL: URL {
        URL(string: "http://any-url.com")!
    }
    
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
    
    private var anyNSError: NSError {
        NSError(domain: "", code: 1)
    }
}

private extension Date {
    func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
       self + seconds
    }
}
