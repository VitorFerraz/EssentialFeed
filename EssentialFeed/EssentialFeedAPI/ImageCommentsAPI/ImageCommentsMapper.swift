//
//  ImageCommentsMapper.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 28/12/22.
//

import EssentialFeed
import Foundation

public enum ImageCommentsMapper {
    private struct Root: Decodable {
        private let items: [Item]

        private struct Item: Decodable {
            let id: UUID
            let message: String
            let created_at: Date
            let author: Author
        }

        private struct Author: Decodable {
            let username: String
        }

        var comments: [ImageComment] {
            items.map { ImageComment(id: $0.id, message: $0.message, createdAt: $0.created_at, username: $0.author.username) }
        }
    }

    private static var OK_200: Int { 200 }
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard isOK(response), let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.comments
    }

    private static func isOK(_ response: HTTPURLResponse) -> Bool {
        (200 ... 299).contains(response.statusCode)
    }
}
