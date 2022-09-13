//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 12/09/22.
//

import Foundation

struct RemoteFeedItem: Equatable, Codable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
