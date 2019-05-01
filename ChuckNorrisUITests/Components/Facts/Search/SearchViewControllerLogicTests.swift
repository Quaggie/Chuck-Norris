//
//  SearchViewControllerLogicTests.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import XCTest
@testable import ChuckNorris

final class SearchViewControllerLogicTests: KIFTestCase {
  var navigationController: UINavigationController!
  var coordinator: FactsCoordinatorProtocol!
  var service: ChuckNorrisWebserviceProtocol!
  var delegate: SearchViewControllerDelegate!
  var database: DatabaseProtocol!
  var defaults: UserDefaults!

  private final class Delegate: SearchViewControllerDelegate {
    func searchViewControllerDidGetSearchFacts() {

    }
  }

  override func beforeEach() {
    navigationController = UINavigationController()
    UIApplication.shared.keyWindow?.rootViewController = navigationController
    defaults = UserDefaults(suiteName: String(describing: FakeDatabase.self))
    defaults.removeObject(forKey: Database.Keys.categories.rawValue)
    defaults.removeObject(forKey: Database.Keys.pastSearches.rawValue)
    database = Database(defaults: defaults)
  }

  override func afterEach() {
    defaults.removeObject(forKey: Database.Keys.categories.rawValue)
    defaults.removeObject(forKey: Database.Keys.pastSearches.rawValue)
  }

  private func setupController(categoryResponseType: FakeChuckNorrisWebserviceCategoryResponseType,
                               searchResponseType: FakeChuckNorrisWebserviceSearchResponseType) {
    service = FakeChuckNorrisWebservice(categoryResponseType: categoryResponseType, searchResponseType: searchResponseType)
    coordinator = FactsCoordinator(navigationController: navigationController)
    delegate = Delegate()
    let controller = SearchViewController(coordinator: coordinator,
                                          delegate: delegate,
                                          service: service,
                                          database: database)
    navigationController.viewControllers = [controller]
  }

  func testOnly8CategoriesCanBeShown() {
    setupController(categoryResponseType: .success, searchResponseType: .success)
    let ninthViewExists = tester.tryFindingView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView8")
    XCTAssertFalse(ninthViewExists)
  }

  func testOnly5PastSearchesCanBeShown() {
    PastSearch.mockPastSearches(total: 6).forEach { (pastSearch) in
      database.save(object: pastSearch, forKey: .pastSearches)
    }
    setupController(categoryResponseType: .success, searchResponseType: .success)
    let fifthViewExists = tester.tryFindingView(withAccessibilityIdentifier: "searchPastSearchCollectionViewCellContentView5")
    XCTAssertFalse(fifthViewExists)
  }

  func testLastPastSearchIsOnTop() {
    PastSearch.mockPastSearches(total: 3).forEach { (pastSearch) in
      database.save(object: pastSearch, forKey: .pastSearches)
    }
    setupController(categoryResponseType: .success, searchResponseType: .success)
    let firstViewBefore = tester.waitForView(withAccessibilityIdentifier: "searchPastSearchCollectionViewCellLabel0") as! UILabel
    XCTAssertTrue(firstViewBefore.text == "Search2")

    tester.enterText("Chuck", intoViewWithAccessibilityIdentifier: "searchViewControllerScreenSearchBar")
    tester.tapView(withAccessibilityLabel: "Search")

    setupController(categoryResponseType: .success, searchResponseType: .success)
    let firstViewAfter = tester.waitForView(withAccessibilityIdentifier: "searchPastSearchCollectionViewCellLabel0") as! UILabel
    XCTAssertTrue(firstViewAfter.text == "Chuck")
  }
}

