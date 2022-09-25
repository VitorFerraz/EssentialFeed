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

}
