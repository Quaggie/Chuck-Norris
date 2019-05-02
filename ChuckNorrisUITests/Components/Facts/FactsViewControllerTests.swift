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
    // Add jokes to defaults
    let jokes = Joke.mockJokes(total: 2)
    database.save(object: jokes, forKey: Database.Keys.facts)
    // Setup controller with previously saved database
    setupController()
    // Look for collectionView
    tester.waitForView(withAccessibilityIdentifier: "factsViewControllerCollectionView")
  }

  func testShare() {
    // Add jokes to defaults
    let jokes = Joke.mockJokes(total: 1)
    database.save(object: jokes, forKey: Database.Keys.facts)
    // Setup controller with previously saved database
    setupController()
    tester.tapView(withAccessibilityIdentifier: "factsCollectionViewCellShareButton")
    // RemoteViewBridge is the activity view from UIKit
    tester.waitForView(withAccessibilityIdentifier: "RemoteViewBridge")
  }

  func testCanOnlyShow10JokesOnAppOpen() {
    // Add jokes to defaults
    let jokes = Joke.mockJokes(total: 20)
    database.save(object: jokes, forKey: Database.Keys.facts)
    // Setup controller with previously saved database
    setupController()
    // Look for collectionView
    let collectionView = tester.waitForView(withAccessibilityIdentifier: "factsViewControllerCollectionView") as! UICollectionView
    let lastItem = collectionView.numberOfItems(inSection: 0)
    collectionView.scrollToItem(at: IndexPath(item: lastItem - 1, section: 0), at: .bottom, animated: false)

    let eleventhView = tester.tryFindingView(withAccessibilityIdentifier: "factsCollectionViewCellContentView10")
    XCTAssertFalse(eleventhView)
  }
}
