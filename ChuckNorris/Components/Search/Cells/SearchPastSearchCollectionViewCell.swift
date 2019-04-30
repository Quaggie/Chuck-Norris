//
//  SearchPastSearchCollectionViewCell.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 29/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class SearchPastSearchCollectionViewCell: UICollectionViewCell {
  // MARK: - Static functions -
  static func size(width: CGFloat) -> CGSize {
    return CGSize(width: width, height: 28)
  }

  // MARK: - Views -
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = Color.black
    label.font = UIFont.systemFont(ofSize: 16)
    label.accessibilityIdentifier = "searchPastSearchCollectionViewCellLabel"
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
  func setup(text: String) {
    titleLabel.text = text
  }
}

extension SearchPastSearchCollectionViewCell: CodeView {
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
    contentView.accessibilityIdentifier = "searchPastSearchCollectionViewCellContentView"
  }
}
