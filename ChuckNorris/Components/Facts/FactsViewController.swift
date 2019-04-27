//
//  FactsViewController.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class FactsViewController: UIViewController {
  // MARK: - Properties -
  private let coordinator: FactsCoordinatorProtocol
  private let service: ChuckNorrisWebserviceProtocol
  private let database: DatabaseProtocol
  private var state: FactsViewControllerViewState = .empty {
    didSet {
      screen.changeUI(for: state)
    }
  }
  private lazy var dataSource = FactsDataSource(collectionView: screen.collectionView, delegate: self, jokes: jokes)
  private var jokes: [Joke] = [] {
    didSet {
      state = jokes.isEmpty ? .empty : .finished
      dataSource = FactsDataSource(collectionView: screen.collectionView, delegate: self, jokes: jokes)
      screen.collectionView.dataSource = dataSource
    }
  }

  // MARK: - Views -
  private let screen = FactsViewControllerScreen()

  // MARK: - Init -
  init(coordinator: FactsCoordinatorProtocol,
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
    setupOfflineData()
    setupCollectionView()
  }
}

// MARK: - Setup -
private extension FactsViewController {
  func setupNavigationItem() {
    navigationItem.title = "Chuck Norris Facts"
    let searchBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                              target: self,
                                              action: #selector(didTapSearch))
    navigationItem.rightBarButtonItem = searchBarButtonItem
  }

  func setupInitialState() {
    state = .empty
  }

  func setupOfflineData() {
    let offlineJokes: [Joke]? = database.getObject(key: Database.Keys.facts.rawValue)
    if let offlineJokes = offlineJokes {
      jokes = offlineJokes
    }
  }

  func setupCollectionView() {
    screen.collectionView.delegate = self
    screen.collectionView.dataSource = dataSource
  }
}

// MARK: - Actions -
private extension FactsViewController {
  @objc func didTapSearch() {
    print("Search pressed")
  }
}

// MARK: - UICollectionViewDelegate -
extension FactsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Item \(indexPath.item) selected")
  }
}

// MARK: - UICollectionViewDelegateFlowLayout -
extension FactsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let joke = jokes[indexPath.item]
    return FactsCollectionViewCell.size(width: collectionView.frame.width - (screen.margin * 2),
                                        text: joke.value)
  }
}

// MARK: - FactsCollectionViewCellDelegate -
extension FactsViewController: FactsCollectionViewCellDelegate {
  func factsCollectionViewCellDidTapShare(joke: Joke) {
    if let url = URL(string: joke.url) {
      coordinator.share(url: url)
    }
  }
}
