//
//  SearchCoordinator.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

protocol SearchCoordinatorProtocol: AnyObject {
  func cancelSearch()
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
//    let nav = UINavigationController(rootViewController: controller)
//    nav.modalTransitionStyle = .crossDissolve
//    navigationController.present(nav, animated: true)
    navigationController.pushViewController(controller, animated: true)
  }
}

extension SearchCoordinator: SearchCoordinatorProtocol {
  func cancelSearch() {
    navigationController.dismiss(animated: true, completion: nil)
  }
}
