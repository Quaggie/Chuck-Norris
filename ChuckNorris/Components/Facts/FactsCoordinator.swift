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
}

final class FactsCoordinator: Coordinator {
  // MARK: - Views -
  private let navigationController: UINavigationController

  // MARK: - Init -
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
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
}
