//
//  SearchViewControllerScreen.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class SearchViewControllerScreen: UIView {
  // MARK: - Public properties -
  let margin: CGFloat = 16

  // MARK: - Private properties -
  private unowned let errorViewDelegate: SearchErrorViewDelegate
  private var errorViewHeightAnchor: NSLayoutConstraint?

  // MARK: - Public views -
  lazy var collectionView: UICollectionView = {
    let flowLayout = LeftAlignedFlowLayout(minimumInteritemSpacing: 8,
                                           minimumLineSpacing: 8,
                                           sectionInset: .init(top: 16, left: 0, bottom: 0, right: 0))
    flowLayout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.contentInset = UIEdgeInsets(top: 0, left: margin, bottom: margin, right: margin)
    collectionView.accessibilityIdentifier = "searchViewControllerScreenCollectionView"
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
  private lazy var errorView = SearchErrorView(delegate: errorViewDelegate)
  private let activityIndicator: UIActivityIndicatorView = {
    let ai = UIActivityIndicatorView(style: .white)
    ai.hidesWhenStopped = true
    ai.color = Color.orange
    ai.accessibilityIdentifier = "searchViewControllerScreenActivityIndicator"
    return ai
  }()

  // MARK: - Init -
  init(errorViewDelegate: SearchErrorViewDelegate) {
    self.errorViewDelegate = errorViewDelegate
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
      searchController.searchBar.isUserInteractionEnabled = true
      searchController.searchBar.isHidden = false
      errorView.isHidden = true
    case .finished:
      collectionView.isHidden = false
      emptyView.isHidden = true
      activityIndicator.stopAnimating()
      searchController.searchBar.isUserInteractionEnabled = true
      searchController.searchBar.isHidden = false
      errorView.isHidden = true
    case .loading:
      collectionView.isHidden = true
      emptyView.isHidden = true
      activityIndicator.startAnimating()
      searchController.searchBar.isUserInteractionEnabled = false
      searchController.searchBar.isHidden = false
      errorView.isHidden = true
    case .error(let error):
      collectionView.isHidden = true
      emptyView.isHidden = true
      activityIndicator.stopAnimating()
      searchController.searchBar.isUserInteractionEnabled = true
      searchController.searchBar.isHidden = true
      errorView.isHidden = false
      errorView.setup(error: error)
      errorViewHeightAnchor?.constant = SearchErrorView.height(error: error, width: frame.width - (margin * 2))
    }
  }
}

// MARK: - CodeView -
extension SearchViewControllerScreen: CodeView {
  func buildViewHierarchy() {
    addSubview(collectionView)
    addSubview(emptyView)
    addSubview(errorView)
    addSubview(activityIndicator)
  }

  func setupConstraints() {
    collectionView.fillSuperview()

    emptyView.anchor(leading: leadingAnchor,
                     trailing: trailingAnchor,
                     insets: .init(top: 0, left: 16, bottom: 0, right: 16))
    emptyView.anchorCenterYToSuperview()
    emptyView.anchor(height: SearchEmptyView.height)

    errorView.anchor(leading: leadingAnchor,
                     trailing: trailingAnchor,
                     insets: .init(top: 0, left: 16, bottom: 0, right: 16))
    errorView.anchorCenterYToSuperview()
    errorViewHeightAnchor = errorView.anchor(height: 0).first

    activityIndicator.anchorCenterSuperview()
  }

  func setupAdditionalConfiguration() {
    backgroundColor = Color.white
    accessibilityIdentifier = "searchViewControllerScreen"
  }
}

