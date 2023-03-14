//
//  FeedEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 13/03/23.
//

import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "limit", value: "10")
            ]
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/v1/feed"

            return components.url!
        }
    }
}
