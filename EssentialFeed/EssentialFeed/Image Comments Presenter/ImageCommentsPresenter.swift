//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 04/01/23.
//

import UIKit

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: ImageCommentsPresenter.self),
            comment: "Title for the feed view")
    }
}
