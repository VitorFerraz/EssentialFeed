//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 04/01/23.
//

import EssentialFeed
import XCTest

class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizaedKeyAndValuesExists(in: bundle, table)
    }
}
