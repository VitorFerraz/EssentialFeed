//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 02/01/23.
//

import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        assertLocalizaedKeyAndValuesExists(in: bundle, table)
    }
    
    // MARK: - Helpers
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }

}
