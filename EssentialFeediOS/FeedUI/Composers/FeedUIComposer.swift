//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 19/10/22.
//

import UIKit
import EssentialFeed

public enum FeedUIComposer {
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let viewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshController = FeedRefreshViewController(viewModel: viewModel)
        let feedController = FeedViewController(refreshController: refreshController)
        viewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                let viewModel = FeedImageViewModel<UIImage>(model: model, imageLoader: loader, imageTransformer: UIImage.init)
                return FeedImageCellController(viewModel: viewModel)
            }
        }
    }
}
