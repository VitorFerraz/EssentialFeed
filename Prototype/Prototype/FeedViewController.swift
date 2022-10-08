//
//  FeedViewController.swift
//  Prototype
//
//  Created by Vitor Ferraz Varela on 08/10/22.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

class FeedViewController: UITableViewController {
    private let feed = FeedImageViewModel.prototypeFeed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as? FeedImageCell else {
            return UITableViewCell()
        }
        let viewModel = feed[indexPath.row]
        
        cell.locationLabel.text = viewModel.location
        cell.feedImageView.image = UIImage(named: viewModel.imageName)
        cell.descriptionLabel.text = viewModel.description
        
        return cell
    }

}
