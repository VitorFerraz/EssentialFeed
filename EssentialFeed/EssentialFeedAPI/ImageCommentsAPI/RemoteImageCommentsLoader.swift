//
//  RemoteImageCommentsLoader.swift
//  EssentialFeedAPI
//
//  Created by Vitor Ferraz Varela on 28/12/22.
//

import Foundation
import EssentialFeed

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
