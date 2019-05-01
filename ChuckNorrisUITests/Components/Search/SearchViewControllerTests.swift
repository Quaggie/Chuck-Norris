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
  var coordinator: FactsCoordinatorProtocol!
  var service: ChuckNorrisWebserviceProtocol!
  var delegate: SearchViewControllerDelegate!
  var database: DatabaseProtocol!

  private final class Delegate: SearchViewControllerDelegate {
    var delegateCalled = false
    func searchViewControllerDidGetSearchFacts() {
      delegateCalled = true
    }
  }

  override func beforeEach() {
    navigationController = UINavigationController()
    UIApplication.shared.keyWindow?.rootViewController = navigationController
    database = FakeDatabase()
  }

  private func setupController(responseType: FakeChuckNorrisWebserviceResponseType) {
    service = FakeChuckNorrisWebservice(responseType: responseType)
    coordinator = FactsCoordinator(navigationController: navigationController)
    delegate = Delegate()
    let controller = SearchViewController(coordinator: coordinator,
                                          delegate: delegate,
                                          service: service,
                                          database: database)
    navigationController.viewControllers = [controller]
  }

  func testSuccess() {
    setupController(responseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenCollectionView")
  }

  func testLoading() {
    setupController(responseType: .loading)
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
  }

  func testServerError() {
    setupController(responseType: .error(ApiError.serverError))
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.serverError.message)
  }

  func testInvalidResponse() {
    setupController(responseType: .error(ApiError.invalidResponse))
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.invalidResponse.message)
  }

  func testEmpty() {
    setupController(responseType: .error(ApiError.empty))
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.empty.message)
  }

  func testDecodingError() {
    setupController(responseType: .error(ApiError.decodingError))
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.decodingError.message)
  }

  func testNoInternet() {
    setupController(responseType: .error(ApiError.noInternet))
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.noInternet.message)
  }

  func testInvalidEndpoint() {
    setupController(responseType: .error(ApiError.invalidEndpoint))
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.invalidEndpoint.message)
  }

  func testCategoriesLayout() {
    // Add jokes to defaults
    let categories = ChuckNorris.Category.mockCategories(total: 8)
    database.save(object: categories, forKey: Database.Keys.categories)
    // Setup controller with previously saved database
    setupController(responseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView")
  }

  func testCategoriesTap() {
    // Add jokes to defaults
    let categories = ChuckNorris.Category.mockCategories(total: 8)
    database.save(object: categories, forKey: Database.Keys.categories)
    // Setup controller with previously saved database
    setupController(responseType: .success)
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView")
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
  }

  func testPastSearchesLayout() {
    // Add jokes to defaults
    let pastSearches = PastSearch.mockPastSearches(total: 5)
    database.save(object: pastSearches, forKey: Database.Keys.pastSearches)
    // Setup controller with previously saved database
    setupController(responseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchPastSearchCollectionViewCellLabel")
  }

  func testPastSearchesTap() {
    // Add jokes to defaults
    let pastSearches = PastSearch.mockPastSearches(total: 1)
    database.save(object: pastSearches, forKey: Database.Keys.pastSearches)
    // Setup controller with previously saved database
    setupController(responseType: .success)
    tester.tapView(withAccessibilityIdentifier: "searchPastSearchCollectionViewCellContentView")
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
  }
}
