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

// MARK: - UISearchBarDelegate -
extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    getSearchRequest(text: searchBar.text)
  }
}
