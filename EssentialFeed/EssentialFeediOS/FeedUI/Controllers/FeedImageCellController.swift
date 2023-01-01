//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 19/10/22.
//

import UIKit

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?
    
    public init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    public func display(_ viewModel: FeedImageViewModel<UIImage>) {
            self.cell?.locationContainer.isHidden = !viewModel.hasLocation
            self.cell?.locationLabel.text = viewModel.location
            self.cell?.descriptionLabel.text = viewModel.description
            self.cell?.feedImageView.setImageAnimated(viewModel.image)
            self.cell?.feedImageView.image = viewModel.image
            self.cell?.feedImageContainer.isShimmering = viewModel.isLoading
            self.cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
            self.cell?.onRetry = self.delegate.didRequestImage        
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
