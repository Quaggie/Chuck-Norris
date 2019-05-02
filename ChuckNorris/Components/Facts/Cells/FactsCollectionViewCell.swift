//
//  FactsCollectionViewCell.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

protocol FactsCollectionViewCellDelegate: AnyObject {
  func factsCollectionViewCellDidTapShare(joke: Joke)
}

final class FactsCollectionViewCell: UICollectionViewCell {
  // MARK: - Static vars -
  static let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

  // MARK: - Static functions -
  static func size(width: CGFloat, text: String) -> CGSize {
    let label = UILabel()
    label.text = text

    let fontSize = getFontSize(from: text)
    label.font = UIFont.boldSystemFont(ofSize: fontSize)

    let cardWidth = width - insets.left - insets.right
    let height = label.height(width: cardWidth)
    let totalHeight = insets.top + height + 8 + 44 + insets.bottom // [inset-text-margin(8)-button(44)-inset]
    return CGSize(width: width, height: totalHeight)
  }

  static func getFontSize(from text: String) -> CGFloat {
    return text.count > 80 ? UIFont.smallSystemFontSize : 28
  }

  static func getCorrectCategory(from categories: [Category]?) -> String {
    if let category = categories?.first {
      return category.uppercased()
    } else {
      return "Uncategorized".uppercased()
    }
  }

  // MARK: - Properties -
  private var joke: Joke?
  private weak var delegate: FactsCollectionViewCellDelegate?

  // MARK: - Views -
  private let label: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = Color.black
    label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    label.accessibilityIdentifier = "factsCollectionViewCellLabel"
    return label
  }()

  private let categoryCardView: UIView = {
    let view = UIView()
    view.backgroundColor = Color.black
    view.layer.cornerRadius = 14
    return view
  }()

  private let categoryCardLabel: UILabel = {
    let label = UILabel()
    label.textColor = Color.white
    label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
    label.accessibilityIdentifier = "factsCollectionViewCellCategoryCardLabel"
    return label
  }()

  private lazy var shareButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "icon_pdf").withRenderingMode(.alwaysTemplate), for: .normal)
    button.imageEdgeInsets = .init(top: 4, left: 4, bottom: 4, right: 4)
    button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    button.accessibilityIdentifier = "factsCollectionViewCellShareButton"
    return button
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
  func setup(joke: Joke, index: Int, delegate: FactsCollectionViewCellDelegate) {
    self.joke = joke
    contentView.accessibilityIdentifier = "factsCollectionViewCellContentView\(index)"
    self.delegate = delegate
    let fontSize = FactsCollectionViewCell.getFontSize(from: joke.value)
    label.font = UIFont.boldSystemFont(ofSize: fontSize)
    label.text = joke.value
    categoryCardLabel.text = FactsCollectionViewCell.getCorrectCategory(from: joke.category)
    shareButton.isHidden = joke.url.isEmpty
  }
}

// MARK: - Actions -
private extension FactsCollectionViewCell {
  @objc func didTapShareButton() {
    guard let joke = joke else {
      fatalError("Missing setup call")
    }
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    delegate?.factsCollectionViewCellDidTapShare(joke: joke)
  }
}

// MARK: - CodeView -
extension FactsCollectionViewCell: CodeView {
  func buildViewHierarchy() {
    contentView.addSubview(label)
    contentView.addSubview(categoryCardView)
    categoryCardView.addSubview(categoryCardLabel)
    contentView.addSubview(shareButton)
  }

  func setupConstraints() {
    label.anchor(top: contentView.topAnchor,
                 leading: contentView.leadingAnchor,
                 trailing: contentView.trailingAnchor,
                 insets: .init(top: FactsCollectionViewCell.insets.top,
                               left: FactsCollectionViewCell.insets.left,
                               bottom: 0,
                               right: FactsCollectionViewCell.insets.right))

    categoryCardView.anchor(leading: contentView.leadingAnchor,
                            insets: .init(top: 0, left: FactsCollectionViewCell.insets.left, bottom: 0, right: 0))
    categoryCardView.centerYAnchor.constraint(equalTo: shareButton.centerYAnchor).isActive = true
    categoryCardView.anchor(height: 28)

    categoryCardLabel.anchor(top: categoryCardView.topAnchor,
                             leading: categoryCardView.leadingAnchor,
                             bottom: categoryCardView.bottomAnchor,
                             trailing: categoryCardView.trailingAnchor,
                             insets: .init(top: 4, left: 16, bottom: 4, right: 16))

    shareButton.anchor(bottom: contentView.bottomAnchor,
                       trailing: contentView.trailingAnchor,
                       insets: .init(top: 8,
                                     left: 0,
                                     bottom: FactsCollectionViewCell.insets.bottom,
                                     right: FactsCollectionViewCell.insets.right))
    shareButton.anchor(height: 44, width: 44)
  }

  func setupAdditionalConfiguration() {
    contentView.backgroundColor = Color.white

    contentView.layer.cornerRadius = 6
    contentView.layer.borderColor = UIColor.clear.cgColor
    contentView.layer.masksToBounds = true

    applyShadow(color: .black,
                offset: CGSize(width: 3, height: 2),
                opacity: 0.12,
                radius: 20)
  }
}
