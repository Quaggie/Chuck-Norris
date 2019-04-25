//
//  FactsViewController.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class FactsViewController: UIViewController {
  // MARK: - Properties
  private let coordinator: FactsCoordinatorProtocol
  private let service: ChuckNorrisWebserviceProtocol

  // MARK: - Init -
  init(coordinator: FactsCoordinatorProtocol, service: ChuckNorrisWebserviceProtocol = ChuckNorrisWebservice()) {
    self.coordinator = coordinator
    self.service = service
    super.init(nibName: nil, bundle: nil)
    navigationItem.title = "Chuck Norris Facts"
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle -
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
}

extension FactsViewController: CodeView {
  func buildViewHierarchy() {

  }

  func setupConstraints() {

  }

  func setupAdditionalConfiguration() {
    view.backgroundColor = .white
  }
}
