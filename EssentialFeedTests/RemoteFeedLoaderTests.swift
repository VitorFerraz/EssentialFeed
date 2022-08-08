//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 04/08/22.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doestNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url: URL = URL(string: "https://www.apple.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url: URL = URL(string: "https://www.apple.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedError: RemoteFeedLoader.Error?
        client.error = NSError(domain: "", code: -1)
        sut.load { error in
            capturedError = error
        }
        
        XCTAssertEqual(capturedError, .connectivity)
    }
    
    // MARK: - Helpers
    private func makeSUT(
        client: HTTPClientSpy = HTTPClientSpy(),
        url: URL = URL(string: "https://www.google.com")!
    ) -> (RemoteFeedLoader, HTTPClientSpy) {
        (RemoteFeedLoader(url: url, client: client), client)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        
        
        var requestURLs = [URL]()
        var error: Error?
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            requestURLs.append(url)
            if let error = error {
                completion(error)
            }
        }
    }
}
