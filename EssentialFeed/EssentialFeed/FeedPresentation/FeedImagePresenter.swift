//
//  FeedImagePresenter.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 26/10/22.
//

import Foundation

public enum FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}
