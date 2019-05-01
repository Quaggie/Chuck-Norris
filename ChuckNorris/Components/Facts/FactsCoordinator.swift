//
//  FactsCoordinator.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

protocol FactsCoordinatorProtocol: AnyObject {
  func share(url: URL)
  func goToSearch()
}

final class FactsCoordinator: Coordinator {
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
    let controller = FactsViewController(coordinator: self)
    navigationController.viewControllers = [controller]
  }
}

// MARK: - FactsCoordinatorProtocol -
extension FactsCoordinator: FactsCoordinatorProtocol {
  func share(url: URL) {
    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = navigationController.presentingViewController?.view
    navigationController.present(activityViewController, animated: true)
  }

  func goToSearch() {
    let controller = SearchViewController(coordinator: self, delegate: self)
    navigationController.pushViewController(controller, animated: true)
  }
}

// MARK: - SearchViewControllerDelegate -
extension FactsCoordinator: SearchViewControllerDelegate {
  func searchViewControllerDidGetSearchFacts() {
    navigationController.viewControllers.forEach({ ($0 as? DatabaseLoadable)?.reloadDatabase() })
    navigationController.popViewController(animated: true)
  }
}
