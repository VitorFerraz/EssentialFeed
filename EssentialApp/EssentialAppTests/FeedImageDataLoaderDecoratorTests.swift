//
//  FeedImageDataLoaderDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Vitor Ferraz Varela on 10/12/22.
//

import XCTest
import EssentialFeed
import EssentialApp

final class FeedImageDataLoaderDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {
    func test_load_deliversFeedImageOnLoaderSuccess() {
        let (sut, spy) = makeSUT()
        let data = anyData()
        expect(sut, toCompleteWith: .success(data)) {
            spy.complete(with: data)
        }
    }
    
    func test_load_deliversErrorOnLoaderFailure() {
        let (sut, spy) = makeSUT()
        expect(sut, toCompleteWith: .failure(anyNSError)) {
            spy.complete(with: anyNSError)
        }
    }
    
    func test_load_cachesLoadedFeedImagedOnLoaderSuccess() {
        let cache = CacheSpy()
        let (sut, spy) = makeSUT(cache: cache)
        
        _ = sut.loadImageData(from: anyURL) { _ in }
        spy.complete(with: anyData())
        
        XCTAssertEqual(cache.image, .save(anyData()))
    }
    
    func test_load_doesNotCacheOnLoaderFailure() {
        let cache = CacheSpy()
        let (sut, spy) = makeSUT(cache: cache)
        
        _ = sut.loadImageData(from: anyURL) { _ in }
        spy.complete(with: anyNSError)
        
        XCTAssertNil(cache.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        cache: FeedImageCache = CacheSpy(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> (FeedImageDataLoader, DataLoaderSpy) {
        let loader = DataLoaderSpy()
        let sut = FeedImageDataLoaderDecorator(
            decoratee: loader,
            cache: cache
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)

        return (sut, loader)
    }
    
    private class CacheSpy: FeedImageCache {
        private(set) var image: Image?
        
        enum Image: Equatable {
            case save(Data)
        }
        func save(
            _ data: Data,
            for url: URL,
            completion: @escaping (SaveResult) -> Void
        ) {
            image = Image.save(data)
            completion(.success(()))
        }
    }
}
