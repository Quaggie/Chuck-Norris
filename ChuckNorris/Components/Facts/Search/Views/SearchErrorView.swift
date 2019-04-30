//
//  SearchErrorView.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 30/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

protocol SearchErrorViewDelegate: AnyObject {
  func searchErrorViewDidTapButton()
}

final class SearchErrorView: UIView {
  // MARK: - Static -
  static func height(error: ApiError, width: CGFloat) -> CGFloat {
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.text = error.message

    let titleHeight = label.height(width: width)
    let spacing: CGFloat = 16
    let buttonHeight: CGFloat = 40
    return titleHeight + spacing + buttonHeight
  }

  // MARK: - Properties -
  private unowned var delegate: SearchErrorViewDelegate

  // MARK: - Views -
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.text = "An unexpected error occurred :("
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }()
  private lazy var button: UIButton = {
    let btn = UIButton(type: .system)
    btn.setTitle("Try again", for: .normal)
    btn.addTarget(self, action: #selector(didTapBtn), for: .touchUpInside)
    btn.backgroundColor = .black
    btn.tintColor = .white
    btn.layer.cornerRadius = 10.0
    btn.layer.borderWidth = 1.0
    btn.layer.borderColor = UIColor.black.cgColor
    return btn
  }()

  // MARK: - Init -
  init(delegate: SearchErrorViewDelegate) {
    self.delegate = delegate
    super.init(frame: .zero)
    setupViews()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public functions -
extension SearchErrorView {
  func setup(error: ApiError) {
    titleLabel.text = error.message
  }
}

// MARK: - Actions -
extension SearchErrorView {
  @objc private func didTapBtn() {
    delegate.searchErrorViewDidTapButton()
  }
}

// MARK: - CodeView -
extension SearchErrorView: CodeView {
  func buildViewHierarchy() {
    addSubview(titleLabel)
    addSubview(button)
  }

  func setupConstraints() {
    titleLabel.anchor(top: topAnchor,
                      leading: leadingAnchor,
                      trailing: trailingAnchor,
                      insets: .zero)

    button.anchor(top: titleLabel.bottomAnchor,
                  leading: leadingAnchor,
                  trailing: trailingAnchor,
                  insets: .init(top: 16, left: 0, bottom: 0, right: 0))
    button.anchor(height: 40)
  }

  func setupAdditionalConfiguration() {

  }
}
