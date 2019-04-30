//
//  SearchEmptyView.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class SearchEmptyView: UIView {
  // MARK: - Static -
  static let height: CGFloat = 220

  // MARK: - Views -
  private let imgView: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "icon_empty").withRenderingMode(.alwaysTemplate))
    iv.contentMode = .scaleAspectFit
    iv.tintColor = Color.black
    return iv
  }()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "No jokes found with the current search 😫"
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.textAlignment = .center
    return label
  }()

  // MARK: - Init -
  override init(frame: CGRect = .zero) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - CodeView -
extension SearchEmptyView: CodeView {
  func buildViewHierarchy() {
    addSubview(imgView)
    addSubview(titleLabel)
  }

  func setupConstraints() {
    imgView.anchor(top: topAnchor,
                   insets: .init(top: 8, left: 0, bottom: 0, right: 0))
    imgView.anchor(height: 100, width: 100)
    imgView.anchorCenterXToSuperview()

    titleLabel.anchor(top: imgView.bottomAnchor,
                      leading: leadingAnchor,
                      trailing: trailingAnchor,
                      insets: .init(top: 16, left: 8, bottom: 0, right: 8))
  }

  func setupAdditionalConfiguration() {
    accessibilityIdentifier = "searchEmptyView"
  }
}
