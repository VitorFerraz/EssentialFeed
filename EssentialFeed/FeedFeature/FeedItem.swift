//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 30/07/22.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
