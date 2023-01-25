//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 23/10/22.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        return location != nil
    }
}
