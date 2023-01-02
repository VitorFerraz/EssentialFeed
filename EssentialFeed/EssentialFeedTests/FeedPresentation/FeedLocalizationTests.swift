//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Vitor Ferraz Varela on 28/10/22.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        assertLocalizaedKeyAndValuesExists(in: bundle, table)
    }
}
