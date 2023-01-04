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

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), url: anyURL)
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let models = [uniqueImage(), uniqueImage()]
    let local = models.map {
        LocalFeedImage(
            id: $0.id,
            description: $0.description,
            location: $0.location,
            url: $0.url
        )
    }
    return (models, local)
}
