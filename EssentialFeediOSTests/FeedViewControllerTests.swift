//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Vitor Ferraz Varela on 08/10/22.
//

import XCTest
@testable import EssentialFeediOS

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) { }
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers
    
    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }

}
