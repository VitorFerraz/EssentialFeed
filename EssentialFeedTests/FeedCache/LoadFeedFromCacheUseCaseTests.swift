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
        let retrievalError = anyNSError
        let exp = expectation(description: "wait for load complete")
        var receivedError: Error?
        
        sut.load { result in
            switch result {
            case .failure(let error):
                receivedError = error
            case .success:
                XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }
        
        store.completeRetrieval(with: retrievalError)
        
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(receivedError as? NSError, retrievalError)
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
    
    private var anyNSError: NSError {
        NSError(domain: "", code: 1)
    }
}
