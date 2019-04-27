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
  private let emptyView = FactsEmptyView()
  private let activityIndicator: UIActivityIndicatorView = {
    let ai = UIActivityIndicatorView(style: .white)
    ai.hidesWhenStopped = true
    ai.color = Color.black
    return ai
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
      collectionView.isHidden = true
      emptyView.isHidden = true
      activityIndicator.startAnimating()
    case .finished:
      collectionView.isHidden = false
      emptyView.isHidden = true
      activityIndicator.stopAnimating()
    case .empty:
      collectionView.isHidden = true
      emptyView.isHidden = false
      activityIndicator.stopAnimating()
    }
  }
}

// MARK: - CodeView -
extension FactsViewControllerScreen: CodeView {
  func buildViewHierarchy() {
    addSubview(collectionView)
    addSubview(emptyView)
    addSubview(activityIndicator)
  }

  func setupConstraints() {
    collectionView.fillSuperview()

    emptyView.anchor(leading: leadingAnchor,
                     trailing: trailingAnchor,
                     insets: .init(top: 0, left: 16, bottom: 0, right: 16))
    emptyView.anchorCenterYToSuperview()
    emptyView.anchor(height: FactsEmptyView.height)

    activityIndicator.anchorCenterSuperview()
  }

  func setupAdditionalConfiguration() {
    backgroundColor = Color.white
    accessibilityIdentifier = "factsViewControllerScreen"
  }
}
