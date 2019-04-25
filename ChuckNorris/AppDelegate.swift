//
//  AppDelegate.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder {
  private var window: UIWindow?
  private var applicationCoordinator: ApplicationCoordinator?

  private func configuredWindow() -> UIWindow {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.tintColor = Color.orange
    self.window = window
    return window
  }

  private func configureNavigationBar() {
    let appearance = UINavigationBar.appearance()
    appearance.barTintColor = Color.black
    appearance.titleTextAttributes = [.foregroundColor: Color.white]
  }
}

extension AppDelegate: UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    configureNavigationBar()
    let window = configuredWindow()
    let applicationCoordinator = ApplicationCoordinator(window: window)
    self.applicationCoordinator = applicationCoordinator
    applicationCoordinator.start()
    return true
  }
}

enum Result<T, E: Error> {
  case success(T)
  case error(E)
}
