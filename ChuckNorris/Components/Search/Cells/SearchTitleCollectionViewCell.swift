//
//  SearchTitleCollectionViewCell.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 29/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

enum SearchTitleType: String {
  case suggestions
  case pastSearches

  var title: String {
    switch self {
    case .suggestions:
      return "Suggestions"
    case .pastSearches:
      return "Past Searches"
    }
  }
}

final class SearchTitleCollectionViewCell: UICollectionViewCell {
  // MARK: - Static functions -
  static func size(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: 28)
  }

  // MARK: - Views -
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = Color.black
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.accessibilityIdentifier = "searchTitleCollectionViewCellLabel"
    return label
  }()

  // MARK: - Init -
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public functions -
  func setup(type: SearchTitleType) {
    titleLabel.text = type.title
  }
}

// MARK: - CodeView -
extension SearchTitleCollectionViewCell: CodeView {
  func buildViewHierarchy() {
    contentView.addSubview(titleLabel)
  }

  func setupConstraints() {
    titleLabel.anchor(leading: contentView.leadingAnchor,
                      trailing: contentView.trailingAnchor,
                      insets: .zero)
    titleLabel.anchorCenterYToSuperview()
  }

  func setupAdditionalConfiguration() {
    contentView.accessibilityIdentifier = "searchTitleCollectionViewCellContentView"
  }
}
