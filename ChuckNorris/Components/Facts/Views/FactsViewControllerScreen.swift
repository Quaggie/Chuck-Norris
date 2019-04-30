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
  let margin: CGFloat = 16

  // MARK: - Views -
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 16
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    collectionView.accessibilityIdentifier = "factsViewControllerCollectionView"
    collectionView.backgroundColor = Color.white
    collectionView.backgroundView?.backgroundColor = Color.white
    return collectionView
  }()
  private let emptyView = FactsEmptyView()

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
    case .finished:
      collectionView.isHidden = false
      emptyView.isHidden = true
    case .empty:
      collectionView.isHidden = true
      emptyView.isHidden = false
    }
  }
}

// MARK: - CodeView -
extension FactsViewControllerScreen: CodeView {
  func buildViewHierarchy() {
    addSubview(collectionView)
    addSubview(emptyView)
  }

  func setupConstraints() {
    collectionView.fillSuperview()

    emptyView.anchor(leading: leadingAnchor,
                     trailing: trailingAnchor,
                     insets: .init(top: 0, left: 16, bottom: 0, right: 16))
    emptyView.anchorCenterYToSuperview()
    emptyView.anchor(height: FactsEmptyView.height)
  }

  func setupAdditionalConfiguration() {
    backgroundColor = Color.white
    accessibilityIdentifier = "factsViewControllerScreen"
  }
}
