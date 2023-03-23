//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 19/10/22.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
