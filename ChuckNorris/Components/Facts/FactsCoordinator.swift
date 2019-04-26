//
//  FactsCoordinator.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

protocol FactsCoordinatorProtocol: AnyObject {
  func share(text: String)
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
    let controller = FactsViewController(coordinator: self, service: service)
    navigationController.viewControllers = [controller]
  }
}

extension FactsCoordinator: FactsCoordinatorProtocol {
  func share(text: String) {
    let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = navigationController.presentingViewController?.view
    navigationController.present(activityViewController, animated: true)
  }
}
