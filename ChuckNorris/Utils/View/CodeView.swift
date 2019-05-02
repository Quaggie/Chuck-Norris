//
//  CodeView.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

protocol CodeView {
  func buildViewHierarchy()
  func setupConstraints()
  func setupAdditionalConfiguration()
  func setupViews()
}

extension CodeView {
  func setupViews() {
    buildViewHierarchy()
    setupConstraints()
    setupAdditionalConfiguration()
  }
}
