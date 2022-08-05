//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 04/08/22.
//

import XCTest
final class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://www.google.com"))
    }
}

class HTTPClient {
    static var shared = HTTPClient()
    func get(from url: URL) {}
}

final class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?
    
   override func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doestNotRequestDataFromURL() {
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
