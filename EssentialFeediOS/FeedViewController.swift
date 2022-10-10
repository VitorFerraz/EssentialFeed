//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 09/10/22.
//

import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
