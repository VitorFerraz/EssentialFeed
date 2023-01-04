//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 16/09/22.
//

import Foundation
import EssentialFeed

extension Date {
    func minusFeedCacheMaxAge() -> Date  {
        adding(days: -feedCacheMaxAgeInDays)
    }
     
    private var feedCacheMaxAgeInDays: Int {
        7
    }
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

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), url: anyURL)
}
