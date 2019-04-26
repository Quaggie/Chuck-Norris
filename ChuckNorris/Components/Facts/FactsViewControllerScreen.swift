//
//  FactsViewControllerScreen.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class FactsViewControllerScreen: UIView {
  // MARK: - Properties -
  let margin: CGFloat = 8

  // MARK: - Views -
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 8
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    collectionView.accessibilityIdentifier = "factsViewControllerCollectionView"
    collectionView.backgroundColor = Color.white
    collectionView.backgroundView?.backgroundColor = Color.white
    return collectionView
  }()


  // MARK: - Init -
  init() {
    super.init(frame: .zero)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func changeUI(for state: FactsViewControllerViewState) {
    switch state {
    case .loading:
      break
    case .finished:
      break
    case .empty:
      break
    case .error:
      break
    }
  }
}

// MARK: - CodeView -
extension FactsViewControllerScreen: CodeView {
  func buildViewHierarchy() {
    addSubview(collectionView)
  }

  func setupConstraints() {
    collectionView.fillSuperview()
  }

  func setupAdditionalConfiguration() {
    backgroundColor = Color.white
    accessibilityIdentifier = "factsViewControllerScreen"
  }
}
