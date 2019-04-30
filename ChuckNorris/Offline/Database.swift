//
//  Database.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
  func save<T: Codable>(object: T, forKey key: Database.Keys)
  func getObject<T: Codable>(key: Database.Keys) -> T?
}

final class Database {
  // MARK: - Keys -
  enum Keys: String {
    case categories
    case facts
    case pastSearches
  }
  // MARK: - Properties -
  private let defaults: UserDefaults

  // MARK: - Init -
  init(defaults: UserDefaults = UserDefaults.standard) {
    self.defaults = defaults
  }
}

// MARK: - DatabaseProtocol -
extension Database: DatabaseProtocol {
  func save<T: Codable>(object: T, forKey key: Database.Keys) {
    let encoder = JSONEncoder()

    switch key {
    case .categories, .facts:
      if let encoded = try? encoder.encode(object) {
        defaults.set(encoded, forKey: key.rawValue)
      }
    case .pastSearches:
      guard let object = object as? PastSearch else {
        return
      }
      // The user can only have 5 past searches
      if var pastSearches: [PastSearch] = getObject(key: key) {
        // Can't have repeated searches
        if let repeatedObjectIndex = pastSearches.firstIndex(where: { $0 == object }) {
          pastSearches.remove(at: repeatedObjectIndex)
          // Put repeated string on top
          object.dateAdded = Date()
        }
        if pastSearches.count >= 5 {
          pastSearches.removeFirst()
        }
        pastSearches.append(object)
        if let encodedPastSearches = try? encoder.encode(pastSearches) {
          defaults.set(encodedPastSearches, forKey: key.rawValue)
        }
      } else {
        // Creating a new array for past searches
        let pastSearches: [PastSearch] = [object]
        if let encoded = try? encoder.encode(pastSearches) {
          defaults.set(encoded, forKey: key.rawValue)
        }
      }
    }
  }

  func getObject<T: Codable>(key: Database.Keys) -> T? {
    if let data = defaults.object(forKey: key.rawValue) as? Data {
      let decoder = JSONDecoder()
      if let object = try? decoder.decode(T.self, from: data) {
        return object
      }
    }
    return nil
  }
}
