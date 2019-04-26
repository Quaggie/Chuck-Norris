//
//  FactsViewControllerTests.swift
//  ChuckNorrisUITests
//
//  Created by jonathan.p.bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import XCTest
@testable import ChuckNorris

final class FactsViewControllerTests: KIFTestCase {
  var navigationController: UINavigationController!
  var coordinator: FactsCoordinator!
  var service: ChuckNorrisWebserviceProtocol!

  override func beforeEach() {
    navigationController = UINavigationController()
    navigationController.navigationBar.isTranslucent = false
    UIApplication.shared.keyWindow?.rootViewController = navigationController
    service = ChuckNorrisWebservice()
    coordinator = FactsCoordinator(navigationController: navigationController, service: service)
    navigationController.viewControllers = [FactsViewController(coordinator: coordinator)]
  }

  func testScreen() {
    tester.waitForView(withAccessibilityIdentifier: "factsViewControllerScreen")
  }
}
