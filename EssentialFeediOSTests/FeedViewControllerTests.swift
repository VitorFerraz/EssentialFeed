//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Vitor Ferraz Varela on 08/10/22.
//

import XCTest
import EssentialFeed
@testable import EssentialFeediOS

final class FeedViewController: UIViewController {
    private var loader: FeedLoader?
   convenience init(loader: FeedLoader) {
       self.init()
       self.loader = loader
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader?.load(completion: { _ in
        
        })
    }
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)

    }
    
    // MARK: - Helpers
    
    class LoaderSpy: FeedLoader {
        private(set) var loadCallCount: Int = 0
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }

}
