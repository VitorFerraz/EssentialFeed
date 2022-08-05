//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 04/08/22.
//

import XCTest
final class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "https://www.google.com")
    }
}

final class HTTPClient {
    static let shared = HTTPClient()
    private init() { }
    var requestedURL: URL?
}
final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doestNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        
        let sut = RemoteFeedLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}
