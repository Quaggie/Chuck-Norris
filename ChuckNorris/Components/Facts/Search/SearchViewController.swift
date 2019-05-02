//
//  SearchViewController.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

protocol SearchViewControllerDelegate: AnyObject {
  func searchViewControllerDidGetSearchFacts()
}

final class SearchViewController: UIViewController {
  // MARK: - Properties -
  private let coordinator: FactsCoordinatorProtocol
  private unowned let delegate: SearchViewControllerDelegate
  private let service: ChuckNorrisWebserviceProtocol
  private let database: DatabaseProtocol
  private var state: SearchViewControllerViewState = .initial {
    didSet {
      if state == .finished {
        delegate.searchViewControllerDidGetSearchFacts()
      } else {
        screen.changeUI(for: state)
      }
    }
  }
  private lazy var dataSource = SearchDataSource(collectionView: screen.collectionView, types: [])
  private var types: [SearchDataSourceType] = [] {
    didSet {
      dataSource = SearchDataSource(collectionView: screen.collectionView, types: types)
      screen.collectionView.dataSource = dataSource
      screen.collectionView.reloadData()
    }
  }

  // MARK: - Views -
  private lazy var screen = SearchViewControllerScreen(errorViewDelegate: self)

  // MARK: - Init -
  init(coordinator: FactsCoordinatorProtocol,
       delegate: SearchViewControllerDelegate,
       service: ChuckNorrisWebserviceProtocol = ChuckNorrisWebservice(),
       database: DatabaseProtocol = Database()) {
    self.coordinator = coordinator
    self.delegate = delegate
    self.service = service
    self.database = database
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    debugPrint("Deinit SearchViewController")
  }

  // MARK: - Lifecycle -
  override func loadView() {
    self.view = screen
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationItem()
    setupSearchController()
    setupCollectionView()
    setupDataSourceTypes()
  }
}

// MARK: - Setup -
private extension SearchViewController {
  func setupNavigationItem() {
    navigationItem.title = "Search facts"
    navigationItem.searchController = screen.searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }

  func setupSearchController() {
    definesPresentationContext = true
    screen.searchController.searchBar.delegate = self
  }

  func setupCollectionView() {
    screen.collectionView.delegate = self
  }

  func setupDataSourceTypes() {
    guard let categories: [Category] = database.getObject(key: .categories), !categories.isEmpty else {
      getCategories()
      return
    }

    let randomCategories = categories.getRandomElements(8)
    var searchDataSourceTypes: [SearchDataSourceType] = [.sectionTitle(.suggestions), .categories(randomCategories)]

    if let pastSearches: [PastSearch] = database.getObject(key: .pastSearches), !pastSearches.isEmpty {
      let last5PastSearches = pastSearches.prefix(5)
      let sortedPastSearches: [PastSearch] = last5PastSearches.sorted(by: { $0.dateAdded.compare($1.dateAdded) == .orderedDescending })
      searchDataSourceTypes += [.sectionTitle(.pastSearches), .pastSearches(sortedPastSearches)]
    }

    types = searchDataSourceTypes
    state = .initial
  }
}

// MARK: - API -
private extension SearchViewController {
  func getCategories() {
    state = .loading
    service.getCategories { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.database.save(object: response, forKey: .categories)
        self.setupDataSourceTypes()
      case .error(let error):
        self.state = .error(error)
      }
    }
  }

  func getSearchRequest(text: String?) {
    guard let text = text else {
      return
    }
    state = .loading
    service.getJokesBySearching(query: text) { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.database.save(object: response.result, forKey: .facts)
        self.database.save(object: PastSearch(text: text), forKey: .pastSearches)
        self.state = .finished
      case .error(let error):
        self.state = .error(error)
      }
    }
  }
}

// MARK: - UICollectionViewDelegate -
extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let type = types[indexPath.section]
    switch type {
    case .sectionTitle:
      break
    case .categories(let categories):
      let category = categories[indexPath.item]
      screen.searchController.searchBar.text = category
      getSearchRequest(text: category)
    case .pastSearches(let searches):
      let pastSearch = searches[indexPath.item]
      screen.searchController.searchBar.text = pastSearch.text
      getSearchRequest(text: pastSearch.text)
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout -
extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let type = types[indexPath.section]
    let width = collectionView.frame.width - (screen.margin * 2)

    switch type {
    case .sectionTitle:
      return SearchTitleCollectionViewCell.size(width: width)
    case .categories(let categories):
      let category = categories[indexPath.item]
      return SearchSuggestionCollectionViewCell.size(width: width, category: category)
    case .pastSearches:
      return SearchPastSearchCollectionViewCell.size(width: width)
    }
  }
}

// MARK: - UISearchBarDelegate -
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    getSearchRequest(text: searchBar.text)
  }
}

// MARK: - SearchErrorViewDelegate -
extension SearchViewController: SearchErrorViewDelegate {
  func searchErrorViewDidTapButton() {
    getSearchRequest(text: screen.searchController.searchBar.text)
  }
}
