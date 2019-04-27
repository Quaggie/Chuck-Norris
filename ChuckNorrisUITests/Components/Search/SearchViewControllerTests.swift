//
//  SearchViewControllerTests.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import XCTest
@testable import ChuckNorris

final class SearchViewControllerTests: KIFTestCase {
  var navigationController: UINavigationController!
  var coordinator: SearchCoordinatorProtocol!
  var service: ChuckNorrisWebserviceProtocol!
  var database: DatabaseProtocol!

  override func beforeEach() {
    navigationController = UINavigationController()
    UIApplication.shared.keyWindow?.rootViewController = navigationController
    database = FakeDatabase()
  }

  private func createCoordinator(responseType: FakeChuckNorrisWebserviceResponseType) {
    service = FakeChuckNorrisWebservice(responseType: responseType)
    coordinator = SearchCoordinator(navigationController: navigationController)
    let controller = SearchViewController(coordinator: coordinator,
                                         service: service,
                                         database: database)
    navigationController.viewControllers = [controller]
  }

  func testSuccess() {
    createCoordinator(responseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerCollectionView")
  }

  func testLoading() {
    createCoordinator(responseType: .loading)
    tester.waitForView(withAccessibilityIdentifier: "searchEmptyView")
  }
}
