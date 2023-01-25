//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 04/01/23.
//

import UIKit

public struct ImageCommentsViewModel {
    public let comments: [ImageCommentViewModel]
}

public struct ImageCommentViewModel: Hashable {
    public let message: String
    public let date: String
    public let username: String

    public init(message: String, date: String, username: String) {
        self.message = message
        self.date = date
        self.username = username
    }
}

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: ImageCommentsPresenter.self),
                                 comment: "Title for the feed view")
    }

    public static func map(_ comments: [ImageComment], calendar: Calendar = .current, locale: Locale = .current) -> ImageCommentsViewModel {
        ImageCommentsViewModel(comments: comments.map { comment in
            let formatter = RelativeDateTimeFormatter()
            formatter.calendar = calendar
            formatter.locale = locale
            return ImageCommentViewModel(
                message: comment.message,
                date: formatter.localizedString(for: comment.createdAt, relativeTo: Date()),
                username: comment.username
            )
        })
    }
}
