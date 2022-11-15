//
//  FeedLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Vitor Ferraz Varela on 15/11/22.
//


import XCTest
import EssentialFeed



final class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primary: FeedLoader
    init(primary: FeedLoader, fallback: FeedLoader) {
        self.primary = primary
    }
    
    func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) {
        primary.load(completion: completion)
    }
}

final class FeedLoaderWithFallbackCompositeTests: XCTestCase {
    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryFeed = uniqueFeed()
        let fallbackFeed = uniqueFeed()
        
        let primaryLoader = LoaderStub(result: .success(primaryFeed))
        let fallbackLoader = LoaderStub(result: .success(fallbackFeed))
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "wait for load completion")
        sut.load { result in
            switch result {
            case let .success(receivedFeed):
                XCTAssertEqual(receivedFeed, primaryFeed)
            case .failure:
                XCTFail("Expected successful load feed result, got \(result) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
    
    private func uniqueFeed() -> [FeedImage] {
        [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
    }
    class LoaderStub: FeedLoader {
        private let result: FeedLoader.Result
        
        init(result: FeedLoader.Result) {
            self.result = result
        }
        func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) {
            completion(result)
        }
    }
    
    
}
