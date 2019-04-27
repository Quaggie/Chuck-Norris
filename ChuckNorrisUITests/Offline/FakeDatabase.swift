//
//  FakeDatabase.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

@testable import ChuckNorris

final class FakeDatabase {
  private var totalJokes: Int = 0
  private var categories: [ChuckNorris.Category] = []

  func reset() {
    totalJokes = 0
    categories = []
  }
}

extension FakeDatabase: DatabaseProtocol {
  func save<T: Codable>(object: T, forKey key: String) {
    guard let keyType = Database.Keys.init(rawValue: key) else {
      return
    }
    switch keyType {
    case .categories:
      if let obj = object as? [ChuckNorris.Category] {
        categories = obj
      }
    case .facts:
      if object is Joke {
        totalJokes += 1
      }
    }
  }

  func getObject<T: Codable>(key: String) -> T? {
    guard let keyType = Database.Keys.init(rawValue: key) else {
      return nil
    }
    switch keyType {
    case .categories:
      return (categories.isEmpty ? nil : categories) as? T
    case .facts:
      return Joke.mockJokes(total: totalJokes) as? T
    }
  }
}
