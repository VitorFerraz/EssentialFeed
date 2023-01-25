//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Vitor Ferraz Varela on 28/10/22.
//

import EssentialFeed
import XCTest

final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizaedKeyAndValuesExists(in: bundle, table)
    }
}
