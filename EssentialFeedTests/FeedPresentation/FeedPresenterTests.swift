//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 05/11/22.
//

import Foundation
import XCTest

final class FeedPresenter {
    init(view: Any) { }
}

final class FeedPresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    private final class ViewSpy {
        let messages: [Any] = []
    }
}
