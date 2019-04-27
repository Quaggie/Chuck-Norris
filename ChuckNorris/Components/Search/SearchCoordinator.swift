//
//  SearchCoordinator.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

protocol SearchCoordinatorProtocol: AnyObject {

}

final class SearchCoordinator: Coordinator {
  // MARK: - Views -
  private let navigationController: UINavigationController
  private let service: ChuckNorrisWebserviceProtocol

  // MARK: - Init -
  init(navigationController: UINavigationController, service: ChuckNorrisWebserviceProtocol = ChuckNorrisWebservice()) {
    self.navigationController = navigationController
    self.service = service
  }

  // MARK: - Coordinator -
  func start() {
    let controller = SearchViewController(coordinator: self, service: service)
    navigationController.pushViewController(controller, animated: true)
  }
}

extension SearchCoordinator: SearchCoordinatorProtocol {

}
