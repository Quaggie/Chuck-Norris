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
  private lazy var dataSource = FactsDataSource(collectionView: screen.collectionView, jokes: jokes)
  private var jokes: [String] =  ["asdfasdfasdfasdfasdf ", "kasjhdfka sjdfajsf jashdf ajhsdfk jahdsfkjads fjhads jfhas djfhas dhfa jshdf jahsdfk ahsdk fjhak sjdhfak jshdfk ajhsfk jahdks jfhas jdfa sjdhfk ajshfk jahsdf jads jfhas jdfhak sjdhfk ajsdhf sdhf", "asdkfhaskdjfhaksjdfhaksjdfh"]

  // MARK: - Views -
  private let screen = FactsViewControllerScreen()

  // MARK: - Init -
  init(coordinator: FactsCoordinatorProtocol, service: ChuckNorrisWebserviceProtocol = ChuckNorrisWebservice()) {
    self.coordinator = coordinator
    self.service = service
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "Chuck Norris Facts"
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
    setupCollectionView()
  }

  // MARK: - Setup -
  private func setupCollectionView() {
    screen.collectionView.delegate = self
    screen.collectionView.dataSource = dataSource
  }
}

// MARK: - UICollectionViewDelegate -
extension FactsViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("Item \(indexPath.item) selected")
  }
}

extension FactsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let joke = jokes[indexPath.item]
    let horizontalMargins = screen.insets.left - screen.insets.right
    return FactsCollectionViewCell.size(width: collectionView.frame.width - horizontalMargins,
                                        text: joke)
  }
}
