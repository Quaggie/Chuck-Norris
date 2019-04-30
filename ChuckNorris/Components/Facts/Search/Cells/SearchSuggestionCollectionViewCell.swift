//
//  SearchSuggestionCollectionViewCell.swift
//  ChuckNorris
//
//  Created by jonathan.p.bijos on 29/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class SearchSuggestionCollectionViewCell: UICollectionViewCell {
  // MARK: - Static public functions -
  static func size(width: CGFloat, category: Category) -> CGSize {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: 28))
    label.lineBreakMode = .byTruncatingTail
    label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    label.text = category
    label.sizeToFit()
    let categoryWidth = label.frame.width + (SearchSuggestionCollectionViewCell.labelHorizontalMargin * 2)

    if categoryWidth > width {
      return CGSize(width: width, height: SearchSuggestionCollectionViewCell.labelHeight)
    }

    return CGSize(width: categoryWidth, height: SearchSuggestionCollectionViewCell.labelHeight)
  }

  // MARK: - Static public properties -
  static let labelHorizontalMargin: CGFloat = 16

  // MARK: - Static private properties -
  private static let labelHeight: CGFloat = 28

  // MARK: - Views -
  private let cardView: UIView = {
    let view = UIView()
    view.backgroundColor = Color.black
    view.layer.cornerRadius = 14
    view.accessibilityIdentifier = "searchSuggestionCollectionViewCellCardView"
    return view
  }()

  private let cardLabel: UILabel = {
    let label = UILabel()
    label.textColor = Color.white
    label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    label.accessibilityIdentifier = "searchSuggestionCollectionViewCellCardLabel"
    label.lineBreakMode = .byTruncatingTail
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

  // MARK: - Highlight -
  override var isHighlighted: Bool {
    didSet {
      UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
        guard let self = self else { return }
        let scale: CGFloat = 0.9
        self.transform = self.isHighlighted ? CGAffineTransform(scaleX: scale, y: scale) : .identity
      })
    }
  }

  // MARK: - Selection -
  override var isSelected: Bool {
    didSet {
      if isSelected {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
      }
    }
  }

  // MARK: - Public functions -
  func setup(category: Category) {
    cardLabel.text = category
  }
}

// MARK: - CodeView -
extension SearchSuggestionCollectionViewCell: CodeView {
  func buildViewHierarchy() {
    contentView.addSubview(cardView)
    cardView.addSubview(cardLabel)
  }

  func setupConstraints() {
    cardView.anchor(top: contentView.topAnchor,
                    leading: contentView.leadingAnchor,
                    bottom: contentView.bottomAnchor,
                    trailing: contentView.trailingAnchor,
                    insets: .zero)

    cardLabel.anchor(top: cardView.topAnchor,
                     leading: cardView.leadingAnchor,
                     bottom: cardView.bottomAnchor,
                     trailing: cardView.trailingAnchor,
                     insets: .init(top: 4,
                                   left: SearchSuggestionCollectionViewCell.labelHorizontalMargin,
                                   bottom: 4,
                                   right: SearchSuggestionCollectionViewCell.labelHorizontalMargin))
  }

  func setupAdditionalConfiguration() {
    contentView.accessibilityIdentifier = "searchSuggestionCollectionViewCellContentView"
  }
}
