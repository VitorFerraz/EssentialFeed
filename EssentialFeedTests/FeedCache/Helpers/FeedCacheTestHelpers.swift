//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 16/09/22.
//

import Foundation
import EssentialFeed

extension Date {
    private var feedCacheMaxAgeInDays: Int {
        7
    }
     
    func minusFeedCacheMaxAge() -> Date  {
        adding(days: -feedCacheMaxAgeInDays)
    }
    
    private func adding(days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
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
