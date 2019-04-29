//
//  SearchViewController.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
  // MARK: - Properties -
  private let coordinator: SearchCoordinatorProtocol
  private let service: ChuckNorrisWebserviceProtocol
  private let database: DatabaseProtocol
  private var state: SearchViewControllerViewState = .initial {
    didSet {
      screen.changeUI(for: state)
    }
  }
  private lazy var dataSource = SearchDataSource(collectionView: screen.collectionView,
                                                 searchSuggestionDelegate: self,
                                                 types: [])
  private var types: [SearchDataSourceType] = [] {
    didSet {
      state = types.isEmpty ? .initial : .finished
      dataSource = SearchDataSource(collectionView: screen.collectionView,
                                    searchSuggestionDelegate: self,
                                    types: types)
      screen.collectionView.dataSource = dataSource
    }
  }

  // MARK: - Views -
  private let screen = SearchViewControllerScreen()

  // MARK: - Init -
  init(coordinator: SearchCoordinatorProtocol,
       service: ChuckNorrisWebserviceProtocol = ChuckNorrisWebservice(),
       database: DatabaseProtocol = Database()) {
    self.coordinator = coordinator
    self.service = service
    self.database = database
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle -
  override func loadView() {
    self.view = screen
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationItem()
    setupInitialState()
    setupSearchController()
    setupCollectionView()
  }
}

// MARK: - Setup -
private extension SearchViewController {
  func setupNavigationItem() {
    navigationItem.title = "Search facts"
    navigationItem.searchController = screen.searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }

  func setupInitialState() {
    state = .initial
  }

  func setupSearchController() {
    definesPresentationContext = true
    screen.searchController.searchBar.delegate = self
  }

  func setupCollectionView() {
    types = [.categories(["Music", "Movie"])]
    screen.collectionView.delegate = self
    screen.collectionView.dataSource = dataSource
    screen.collectionView.reloadData()
  }
}

// MARK: - Actions -
private extension SearchViewController {
  @objc func close() {
    coordinator.cancelSearch()
  }
}

// MARK: - API -
private extension SearchViewController {
  func getSearchRequest(text: String?) {
    guard let text = text else {
      return
    }
    state = .loading
    service.getJokesBySearching(query: text) { [weak self] (result) in
      guard let self = self else { return }
      switch result {
      case .success(let response):
        self.database.save(object: response.result, forKey: Database.Keys.facts.rawValue)
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
    print("Item \(indexPath.section) selected")
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
      return .zero
    case .categories(let categories):
      let category = categories[indexPath.item]
      return SearchSuggestionCollectionViewCell.size(width: width, category: category)
    case .pastSearches(let searches):
      return .zero
    }
  }
}

// MARK: - UISearchBarDelegate -
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    getSearchRequest(text: searchBar.text)
  }
}

// MARK: - SearchSuggestionCollectionViewCellDelegate -
extension SearchViewController: SearchSuggestionCollectionViewCellDelegate {
  func searchSuggestionCollectionViewCellDidTapCategory(category: Category) {
    print(category)
  }
}
