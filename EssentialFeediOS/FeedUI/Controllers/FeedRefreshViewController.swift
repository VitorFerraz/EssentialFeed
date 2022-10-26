//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 19/10/22.
//

import UIKit

protocol FeedRefreshViewcontrollerDelegate {
    func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {
    @IBOutlet var view: UIRefreshControl?
    
    var delegate: FeedRefreshViewcontrollerDelegate?
    
    @IBAction func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view?.beginRefreshing()
        } else {
            view?.endRefreshing()
        }
    }
}
