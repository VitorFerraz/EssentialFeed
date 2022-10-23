//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Vitor Ferraz Varela on 23/10/22.
//

import UIKit
import EssentialFeed

final class FeedImageViewModel {
    typealias Observer<T> = (T) -> Void
    
    private var model: FeedImage
    private var imageLoader: FeedImageDataLoader
    var hasLocation: Bool {
        model.location != nil
    }
    var location: String? {
        model.location
    }
    var description: String? {
        model.description
    }
    private var task: FeedImageDataLoaderTask?
    var onImageLoad: Observer<UIImage>?
    var onShouldRetryImageLoadStateChange: Observer<Bool>?
    var onImageLoadingStateChange: Observer<Bool>?
    
    
    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadStateChange?(false)
        self.task = self.imageLoader.loadImageData(from: self.model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
