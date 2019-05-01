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
  private var pastSearches: [PastSearch] = []

  func reset() {
    totalJokes = 0
    categories = []
  }
}

extension FakeDatabase: DatabaseProtocol {
  func save<T>(object: T, forKey key: Database.Keys) where T : Decodable, T : Encodable {
    switch key {
    case .categories:
      if let obj = object as? [ChuckNorris.Category] {
        categories = obj
      }
    case .facts:
      if object is Joke {
        totalJokes += 1
      }
    case .pastSearches:
      if let obj = object as? [PastSearch] {
        pastSearches = obj
      }
    }

  }

  func getObject<T>(key: Database.Keys) -> T? where T : Decodable, T : Encodable {
    switch key {
    case .categories:
      return (categories.isEmpty ? nil : categories) as? T
    case .facts:
      return Joke.mockJokes(total: totalJokes) as? T
    case .pastSearches:
      return (pastSearches.isEmpty ? nil : pastSearches) as? T
    }
  }
}
