//
//  ResourceErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 05/11/22.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}

