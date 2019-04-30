//
//  SearchDataSource.swift
//  ChuckNorris
//
//  Created by jonathan.p.bijos on 29/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

enum SearchDataSourceType {
  case sectionTitle(SearchTitleType)
  case categories([Category])
  case pastSearches([PastSearch])
}

final class SearchDataSource: NSObject {
  // MARK: - Properties -
  private let types: [SearchDataSourceType]
  private unowned let searchSuggestionDelegate: SearchSuggestionCollectionViewCellDelegate

  // MARK: - Init -
  init(collectionView: UICollectionView,
       searchSuggestionDelegate: SearchSuggestionCollectionViewCellDelegate,
       types: [SearchDataSourceType]) {
    self.searchSuggestionDelegate = searchSuggestionDelegate
    self.types = types
    super.init()
    register(collectionView: collectionView)
  }

  // MARK: - Setup -
  private func register(collectionView: UICollectionView) {
    collectionView.register(SearchTitleCollectionViewCell.self)
    collectionView.register(SearchSuggestionCollectionViewCell.self)
    collectionView.register(SearchPastSearchCollectionViewCell.self)
  }
}

// MARK: - UICollectionViewDataSource -
extension SearchDataSource: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return types.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    let type = types[section]
    switch type {
    case .sectionTitle:
      return 1
    case .categories(let categories):
      return categories.count
    case .pastSearches(let searches):
      return searches.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let type = types[indexPath.section]
    
    switch type {
    case .sectionTitle(let titleType):
      let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SearchTitleCollectionViewCell
      cell.setup(type: titleType)
      return cell
    case .categories(let categories):
      let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SearchSuggestionCollectionViewCell
      let category = categories[indexPath.item]
      cell.setup(category: category)
      return cell
    case .pastSearches(let searches):
      let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as SearchPastSearchCollectionViewCell
      let text = searches[indexPath.item]
      cell.setup(text: text)
      return cell
    }
  }
}
