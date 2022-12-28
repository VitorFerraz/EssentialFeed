//
//  ImageCommentsMapper.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 28/12/22.
//

import Foundation

struct ImageCommentsMapper {
    private struct Root: Codable {
        let items: [RemoteFeedItem]
    }
    
    private static var OK_200: Int { 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }
        return root.items
    }
}
