//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Vitor Ferraz Varela on 15/11/22.
//

import Foundation
import EssentialFeed

var anyURL: URL {
    URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    Data("any data".utf8)
}

var anyNSError: NSError {
    NSError(domain: "any error", code: 0)
}


func uniqueFeed() -> [FeedImage] {
    [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "http://any-url.com")!)]
}

