//
//  FeedEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 13/03/23.
//

import Foundation
import EssentialFeed

public enum FeedEndpoint {
    case get(after: FeedImage? = nil)

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(let image):
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10"),
                image.map { URLQueryItem(name: "after_id", value: $0.id.uuidString)}
            ].compactMap { $0 }
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"

            return components.url!
        }
    }
}
