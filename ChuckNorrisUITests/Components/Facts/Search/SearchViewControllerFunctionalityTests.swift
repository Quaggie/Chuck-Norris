//
//  SearchViewControllerFunctionalityTests.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import XCTest
@testable import ChuckNorris

final class SearchViewControllerFunctionalityTests: KIFTestCase {
  var navigationController: UINavigationController!
  var coordinator: FactsCoordinatorProtocol!
  var service: ChuckNorrisWebserviceProtocol!
  var delegate: SearchViewControllerDelegate!
  var database: DatabaseProtocol!
  var defaults: UserDefaults!

  private final class Delegate: SearchViewControllerDelegate {
    var delegateCalled = false
    func searchViewControllerDidGetSearchFacts() {
      delegateCalled = true
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

  // MARK: - Setup -
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

  private func addOneCategoryToDatabase() {
    let categories = ChuckNorris.Category.mockCategories(total: 8)
    database.save(object: categories, forKey: Database.Keys.categories)
  }

  private func addOnePastSearchToDatabase() {
    let pastSearches = PastSearch.mockPastSearches(total: 1)
    pastSearches.forEach { (pastSearch) in
      database.save(object: pastSearch, forKey: Database.Keys.pastSearches)
    }
  }

  // CATEGORY -----
  func testCategoriesLoadingScreen() {
    setupController(categoryResponseType: .loading, searchResponseType: .loading)
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
  }

  func testCategoriesServerError() {
    setupController(categoryResponseType: .error(ApiError.serverError), searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.serverError.message)
  }

  func testCategoriesInvalidResponse() {
    setupController(categoryResponseType: .error(ApiError.invalidResponse), searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.invalidResponse.message)
  }

  func testCategoriesEmpty() {
    setupController(categoryResponseType: .error(ApiError.empty), searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.empty.message)
  }

  func testCategoriesDecodingError() {
    setupController(categoryResponseType: .error(ApiError.decodingError), searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.decodingError.message)
  }

  func testCategoriesNoInternet() {
    setupController(categoryResponseType: .error(ApiError.noInternet), searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.noInternet.message)
  }

  func testCategoriesInvalidEndpoint() {
    setupController(categoryResponseType: .error(ApiError.invalidEndpoint), searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.invalidEndpoint.message)
  }

  // SEARCH ----
  func testSearchDefaultScreenWithNoCategoriesAndNoPastSearches() {
    setupController(categoryResponseType: .success, searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenCollectionView")
  }

  func testSearchLoadingScreen() {
    setupController(categoryResponseType: .success, searchResponseType: .loading)
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
  }

  func testSearchServerError() {
    setupController(categoryResponseType: .success, searchResponseType: .error(ApiError.serverError))
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.serverError.message)
  }

  func testSearchInvalidResponse() {
    setupController(categoryResponseType: .success, searchResponseType: .error(ApiError.invalidResponse))
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.invalidResponse.message)
  }

  func testSearchEmpty() {
    setupController(categoryResponseType: .success, searchResponseType: .error(ApiError.empty))
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.empty.message)
  }

  func testSearchDecodingError() {
    setupController(categoryResponseType: .success, searchResponseType: .error(ApiError.decodingError))
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.decodingError.message)
  }

  func testSearchNoInternet() {
    setupController(categoryResponseType: .success, searchResponseType: .error(ApiError.noInternet))
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.noInternet.message)
  }

  func testSearchInvalidEndpoint() {
    setupController(categoryResponseType: .success, searchResponseType: .error(ApiError.invalidEndpoint))
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchErrorView")
    let titleLabel = tester.waitForView(withAccessibilityIdentifier: "searchErrorViewTitleLabel") as! UILabel
    XCTAssertTrue(titleLabel.text == ApiError.invalidEndpoint.message)
  }

  func testCategoriesLayout() {
    setupController(categoryResponseType: .success, searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
  }

  func testCategoriesTap() {
    setupController(categoryResponseType: .success, searchResponseType: .success)
    tester.tapView(withAccessibilityIdentifier: "searchSuggestionCollectionViewCellContentView7")
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
    let dlg = delegate as! Delegate
    XCTAssertTrue(dlg.delegateCalled)
  }

  func testAssurePastSearchesLayoutIsOnlyWhenASearchWasMade() {
    setupController(categoryResponseType: .success, searchResponseType: .success)
    let pastSearchIsAvailable = tester.tryFindingView(withAccessibilityIdentifier: SearchTitleType.pastSearches.accessibilityIdentifier)
    XCTAssertFalse(pastSearchIsAvailable)

    setupController(categoryResponseType: .success, searchResponseType: .success)
    // Enter text into searchbar
    tester.enterText("Chuck", intoViewWithAccessibilityIdentifier: "searchViewControllerScreenSearchBar")
    // Tap search on the keyboard
    tester.tapView(withAccessibilityLabel: NSLocalizedString("Search", comment: ""))

    // Reset view
    setupController(categoryResponseType: .success, searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: SearchTitleType.pastSearches.accessibilityIdentifier)
  }

  func testPastSearchesLayout() {
    addOnePastSearchToDatabase()
    setupController(categoryResponseType: .success, searchResponseType: .success)
    tester.waitForView(withAccessibilityIdentifier: "searchPastSearchCollectionViewCellLabel0")
  }

  func testPastSearchesTap() {
    addOnePastSearchToDatabase()
    setupController(categoryResponseType: .success, searchResponseType: .success)
    tester.tapView(withAccessibilityIdentifier: "searchPastSearchCollectionViewCellContentView0")
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
    let dlg = delegate as! Delegate
    XCTAssertTrue(dlg.delegateCalled)
  }

  func testSearchbarEnter() {
    setupController(categoryResponseType: .success, searchResponseType: .success)
    // Enter text into searchbar
    tester.enterText("Chuck", intoViewWithAccessibilityIdentifier: "searchViewControllerScreenSearchBar")
    // Tap search on the keyboard
    tester.tapView(withAccessibilityLabel: NSLocalizedString("Search", comment: ""))
    tester.waitForView(withAccessibilityIdentifier: "searchViewControllerScreenActivityIndicator")
    let dlg = delegate as! Delegate
    XCTAssertTrue(dlg.delegateCalled)
  }
}
