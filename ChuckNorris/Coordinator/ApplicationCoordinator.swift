//
//  ApplicationCoordinator.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

final class ApplicationCoordinator: Coordinator {
  // MARK: - Properties -
  private let window: UIWindow
  private let factsCoordinator: Coordinator
  private let navigationController = UINavigationController()

  // MARK: - Init -
  init(window: UIWindow) {
    self.window = window
    factsCoordinator = FactsCoordinator(navigationController: navigationController)
  }

  // MARK: - Coordinator -
  func start() {
    window.makeKeyAndVisible()
    window.rootViewController = navigationController
    factsCoordinator.start()
  }
}
