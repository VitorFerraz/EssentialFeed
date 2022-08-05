//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 04/08/22.
//

import XCTest
final class RemoteFeedLoader {
    
}

final class HTTPClient {
    var requestedURL: URL?
}
final class RemoteFeedLoaderTests: XCTestCase {
    func test_init_doestNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}
