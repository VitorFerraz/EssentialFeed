//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 25/09/22.
//

import XCTest
import EssentialFeed

final class CodableFeedStore {
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timestamp: Date
        
        var locaFeed: [LocalFeedImage] {
            feed.map{ $0.local }
        }
    }
    
    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL
        
        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
        
        var local: LocalFeedImage {
            LocalFeedImage(id: id, description: description, location: location, url: url)
        }
    }
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.locaFeed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timestamp: timestamp)
        let encoded = try! encoder.encode(cache)
        try! encoded.write(to: storeURL)
        completion(nil)
    }
}

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
        let sut = makeSUT()
        let exp = expectation(description: "wait for cache retrieval")
        sut.retrieve { firstResult in
            switch firstResult {
            case .empty:
                sut.retrieve { secondResult in
                    switch (firstResult, secondResult) {
                    case (.empty, .empty):
                        break
                    default:
                        XCTFail("Expected retriving twice from empty cache to deliver same empty result, but got \(firstResult) and \(secondResult) instead")

                    }
                    exp.fulfill()
                }
            default:
                XCTFail("Expected empty result, got \(firstResult) instead")
            }
            
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_retriveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let exp = expectation(description: "wait for cache retrieval")
        let timestamp = Date()
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            sut.retrieve { retrieveResult in
                switch retrieveResult {
                case let .found(retrivedFeed, retrievedTimestamp):
                    XCTAssertEqual(retrivedFeed, feed)
                    XCTAssertEqual(retrievedTimestamp, timestamp)
                default:
                    XCTFail("Expected found result with feed \(feed) and timestamp \(timestamp), got \(retrieveResult) instead")
                    
                }
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    func test_retrive_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = uniqueImageFeed().local
        let exp = expectation(description: "wait for cache retrieval")
        let timestamp = Date()
        sut.insert(feed, timestamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            sut.retrieve { firstResult in
                sut.retrieve { secondResult in
                    switch (firstResult, secondResult) {
                    case let (.found(firstFound), .found(secondFound)):
                        XCTAssertEqual(firstFound.feed, secondFound.feed)
                        XCTAssertEqual(firstFound.timestamp, secondFound.timestamp)
                    default:
                        XCTFail("Expected retriving twice from non empty cache to deliver same result with feed \(feed), and timestamp \(timestamp), but got \(firstResult) and \(secondResult) instead")

                    }
                    exp.fulfill()
                }
            }
        }
        
        wait(for: [exp], timeout: 1)
    }

    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore(storeURL: testSpecificStoreURL())
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
        FileManager.default.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )
        .first!
        .appendingPathComponent("\(type(of: self)).store")
    }
}
