//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 25/09/22.
//

import XCTest
import EssentialFeed

final class CodableFeedStore {
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        completion(.empty)
    }

}

final class CodableFeedStoreTests: XCTestCase {

    func test_retrive_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "wait for cache retrieval")
        sut.retrieve { result in
            switch result {
            case .empty:
                break
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_retrive_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "wait for cache retrieval")
        sut.retrieve { firstResult in
            switch firstResult {
            case .empty:
                sut.retrieve { secondResult in
                    switch (firstResult, secondResult) {
                    case (.empty, .empty):
                        break
                    default:
                        XCTFail("Expected retriving twice from empty cache to deliver same empty result result, got \(firstResult) and \(secondResult) instead")

                    }
                    exp.fulfill()
                }
            default:
                XCTFail("Expected empty result, got \(firstResult) instead")
            }
            
        }
        
        wait(for: [exp], timeout: 1)
    }

}
