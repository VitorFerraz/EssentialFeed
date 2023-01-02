//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Vitor Ferraz Varela on 02/01/23.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> View.ResourceViewModel
    private let resourceView: View
    private let loadingView: FeedLoadingView
    private let errorView: FeedErrorView
    private let mapper: Mapper

    public init(resourceView: View, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }

    public static var loadError: String {
        return NSLocalizedString("GENERIC_CONNECTION_ERROR",
             tableName: "Shared",
             bundle: Bundle(for: Self.self),
             comment: "Error message displayed when we can't load the resource from the server")
    }

    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: Resource) {
        let viewModel = mapper(resource)
        resourceView.display(viewModel)
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: Self.loadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}