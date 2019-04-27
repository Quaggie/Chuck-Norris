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
  var coordinator: FactsCoordinatorProtocol!
  var database: DatabaseProtocol!
  var defaults: UserDefaults!

  override func beforeEach() {
    navigationController = UINavigationController()
    UIApplication.shared.keyWindow?.rootViewController = navigationController
    defaults = UserDefaults(suiteName: String(describing: FakeDatabase.self))
    defaults.removeObject(forKey: Database.Keys.facts.rawValue)
    database = Database(defaults: defaults)
  }

  override func afterEach() {
    defaults.removeObject(forKey: Database.Keys.facts.rawValue)
  }

  func setupController() {
    coordinator = FactsCoordinator(navigationController: navigationController)
    let controller = FactsViewController(coordinator: coordinator, database: database)
    navigationController.viewControllers = [controller]
  }

  func testEmpty() {
    // Setup controller with empty database
    setupController()
    // Look for emptyView
    tester.waitForView(withAccessibilityIdentifier: "factsEmptyView")
  }

  func testFinished() {
    // Add jokes to default
    let jokes = Joke.mockJokes(total: 2)
    database.save(object: jokes, forKey: Database.Keys.facts.rawValue)
    // Setup controller with previously saved database
    setupController()
    // Look for collectionView
    tester.waitForView(withAccessibilityIdentifier: "factsViewControllerCollectionView")
  }
}
