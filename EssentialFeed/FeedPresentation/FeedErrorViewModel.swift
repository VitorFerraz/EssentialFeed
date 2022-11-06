//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 05/11/22.
//

import Foundation

public struct FeedErrorViewModel {
    public let message: String?
    
    static var noError: FeedErrorViewModel {
        return FeedErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> FeedErrorViewModel {
        return FeedErrorViewModel(message: message)
    }
}

