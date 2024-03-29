//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Vitor Ferraz Varela on 11/12/22.
//

@testable import EssentialApp
import EssentialFeediOS
import XCTest

final class SceneDelegateTests: XCTestCase {
    func test_sceneWillConnectToSession_configuresRootViewController() throws {
        let sut = SceneDelegate()
        sut.window = UIWindow()

        sut.configureWindow()

        let root = try XCTUnwrap(sut.window?.rootViewController)
        let rootNavigation = try XCTUnwrap(root as? UINavigationController)
        let topController = rootNavigation.topViewController

        XCTAssertTrue(topController is ListViewController)
    }
}
