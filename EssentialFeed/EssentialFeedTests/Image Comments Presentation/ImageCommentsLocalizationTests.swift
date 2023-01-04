//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Vitor Ferraz Varela on 04/01/23.
//

import XCTest
import EssentialFeed

class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        assertLocalizaedKeyAndValuesExists(in: bundle, table)
    }

}
