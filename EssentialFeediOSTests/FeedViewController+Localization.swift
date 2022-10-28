//
//  FeedViewController+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Vitor Ferraz Varela on 28/10/22.
//

import Foundation
import XCTest
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in  table: \(table)", file: file, line: line)
        }
        
        return value
    }
}
