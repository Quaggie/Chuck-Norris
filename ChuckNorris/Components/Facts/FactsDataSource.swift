//
//  FactsDataSource.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class FactsDataSource: NSObject {
  // MARK: - Properties -
  private let jokes: [String]

  // MARK: - Init -
  init(collectionView: UICollectionView, jokes: [String]) {
    self.jokes = jokes
    super.init()
    register(collectionView: collectionView)
  }

  // MARK: - Setup -
  private func register(collectionView: UICollectionView) {
    collectionView.register(FactsCollectionViewCell.self)
  }
}

// MARK: - UICollectionViewDataSource -
extension FactsDataSource: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return jokes.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as FactsCollectionViewCell
    let joke = jokes[indexPath.item]
    cell.setup(text: joke)
    return cell
  }
}