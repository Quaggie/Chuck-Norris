//
//  FactsCollectionViewCell.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class FactsCollectionViewCell: UICollectionViewCell {
  // MARK: - Static vars -
  static let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

  // MARK: - Static functions -
  static func size(width: CGFloat, text: String) -> CGSize {
    let correctWidth = width - insets.left - insets.right

    let label = UILabel()
    label.text = text

    let fontSize = getFontSize(from: text)
    label.font = UIFont.boldSystemFont(ofSize: fontSize)

    let height = label.height(width: correctWidth)
    let correctHeight = height + insets.top + insets.bottom
    return CGSize(width: correctWidth, height: correctHeight)
  }

  static func getFontSize(from text: String) -> CGFloat {
    return text.count > 80 ? UIFont.smallSystemFontSize : 28
  }

  // MARK: - Views -

  private let label: UILabel = {
    let label = UILabel(frame: .zero)
    label.numberOfLines = 0
    label.textColor = Color.black
    label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    label.accessibilityIdentifier = "factsCollectionViewCellLabel"
    return label
  }()

  // MARK: - Public functions -
  func setup(text: String) {
    let fontSize = FactsCollectionViewCell.getFontSize(from: text)
    label.font = UIFont.boldSystemFont(ofSize: fontSize)
    label.text = text
    setupViews()
  }
}

// MARK: - CodeView -
extension FactsCollectionViewCell: CodeView {
  func buildViewHierarchy() {
    contentView.addSubview(label)
  }

  func setupConstraints() {
    label.anchor(top: contentView.topAnchor,
                 leading: contentView.leadingAnchor,
                 bottom: contentView.bottomAnchor,
                 trailing: contentView.trailingAnchor,
                 insets: FactsCollectionViewCell.insets)
  }

  func setupAdditionalConfiguration() {
    contentView.backgroundColor = Color.white

    contentView.layer.cornerRadius = 6
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

    applyShadow(color: .black,
                offset: CGSize(width: 3, height: 2),
                opacity: 0.09, radius: 24,
                shadowPath: UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath)

    contentView.accessibilityIdentifier = "factsCollectionViewCellContentView"
  }
}
