//
//  SearchViewControllerScreen.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class SearchViewControllerScreen: UIView {
  // MARK: - Properties -
  let margin: CGFloat = 8

  // MARK: - Public views -
  lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 8
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.contentInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    collectionView.accessibilityIdentifier = "searchViewControllerCollectionView"
    collectionView.backgroundColor = Color.white
    collectionView.backgroundView?.backgroundColor = Color.white
    return collectionView
  }()
  let searchController: UISearchController = {
    let sc = UISearchController(searchResultsController: nil)
    sc.dimsBackgroundDuringPresentation = false
    return sc
  }()
  // MARK: - Private views -
  private let emptyView = SearchEmptyView()
  // TODO: Error view here -> ()
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

  func changeUI(for state: SearchViewControllerViewState) {
    switch state {
    case .initial:
      collectionView.isHidden = false
      emptyView.isHidden = true
      activityIndicator.stopAnimating()
    case .finished:
      collectionView.isHidden = false
      emptyView.isHidden = true
      activityIndicator.stopAnimating()
    case .loading:
      collectionView.isHidden = true
      emptyView.isHidden = true
      activityIndicator.startAnimating()
    case .error(let error):
      print(error)
    }
  }
}

// MARK: - CodeView -
extension SearchViewControllerScreen: CodeView {
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
    emptyView.anchor(height: SearchEmptyView.height)

    activityIndicator.anchorCenterSuperview()
  }

  func setupAdditionalConfiguration() {
    backgroundColor = Color.white
    accessibilityIdentifier = "searchViewControllerScreen"
  }
}

