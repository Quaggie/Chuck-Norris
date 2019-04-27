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
  internal var window: UIWindow?
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
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    configureNavigationBar()
    let window = configuredWindow()
    let applicationCoordinator = ApplicationCoordinator(window: window)
    self.applicationCoordinator = applicationCoordinator
    applicationCoordinator.start()

    // TODO: REMOVE(MOCK)
//    var jokes: [Joke] = []
//    jokes.append(Joke(category: ["Film"], iconUrl: "", id: "", url: "", value: "kasjhdfka sjdfajsf jashdf ajhsdfk jahdsfkjads fjhads jfhas djfhas dhfa jshdf jahsdfk ahsdk fjhak sjdhfak jshdfk ajhsfk jahdks jfhas jdfa sjdhfk ajshfk jahsdf jads jfhas jdfhak sjdhfk ajsdhf sdhf  dhfa jshdf jahsdfk ahsdk fjhak sjdhfak jshdfk ajhsfk jahdks"))
//    jokes.append(Joke(category: ["Music"], iconUrl: "", id: "", url: "https://google.com", value: "asdfasdfasdfasdfasdf"))
//    jokes.append(Joke(category: ["Film"], iconUrl: "", id: "", url: "https://google.com", value: "kasjhdfka sjdfajsf jashdf ajhsdfk jahdsfkjads fjhads jfhas djfhas dhfa jshdf jahsdfk ahsdk fjhak sjdhfak jshdfk ajhsfk jahdks jfhas jdfa sjdhfk ajshfk jahsdf jads jfhas jdfhak sjdhfk ajsdhf sdhf  dhfa jshdf jahsdfk ahsdk fjhak sjdhfak jshdfk ajhsfk jahdks jfhas jdfa"))
//    jokes.append(Joke(category: nil, iconUrl: "", id: "", url: "https://google.com", value: "asdkfhaskdjfhaksjdfhaksjdfh asdfas"))
//    jokes.append(Joke(category: ["Music"], iconUrl: "", id: "", url: "https://google.com", value: "asdfasdfasdfasdfasdf asdfasdfasdfasdfasdf"))
//    jokes.append(Joke(category: ["Music"], iconUrl: "", id: "", url: "https://google.com", value: "AHdfas dfiuasdyfa9sdyf asdfasdfiasdiufa sdifuahsdf asdfasd"))
//
//    let database = Database()
//    database.save(object: jokes, forKey: Database.Keys.facts.rawValue)

    return true
  }
}
