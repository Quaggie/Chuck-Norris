//
//  SearchViewController.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
  // MARK: - Properties -
  private let coordinator: SearchCoordinatorProtocol
  private let service: ChuckNorrisWebserviceProtocol
  private let database: DatabaseProtocol
  private var state: SearchViewControllerViewState = .initial {
    didSet {
      screen.changeUI(for: state)
    }
  }

  // MARK: - Views -
  private let screen = SearchViewControllerScreen()

  // MARK: - Init -
  init(coordinator: SearchCoordinatorProtocol,
       service: ChuckNorrisWebserviceProtocol = ChuckNorrisWebservice(),
       database: DatabaseProtocol = Database()) {
    self.coordinator = coordinator
    self.service = service
    self.database = database
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle -
  override func loadView() {
    self.view = screen
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
