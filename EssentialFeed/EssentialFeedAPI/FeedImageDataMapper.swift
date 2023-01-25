//
//  FeedImageDataMapper.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 02/01/23.
//

import Foundation

public enum FeedImageDataMapper {
    public enum Error: Swift.Error {
        case invalidDate
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidDate
        }

        return data
    }
}
