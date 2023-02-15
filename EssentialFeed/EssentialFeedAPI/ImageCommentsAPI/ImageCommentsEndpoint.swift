//
//  ImageCommentsEndpoint.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 25/01/23.
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(UUID)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/v1/image/\(id)/comments")
        }
    }
}
