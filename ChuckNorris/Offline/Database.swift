//
//  Database.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation

protocol DatabaseProtocol {
  func save<T: Codable>(object: T, forKey key: String)
  func getObject<T: Codable>(key: String) -> T?
}

final class Database {
  enum Keys: String {
    case facts
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
  func save<T: Codable>(object: T, forKey key: String) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(object) {
      defaults.set(encoded, forKey: key)
    }
  }

  func getObject<T: Codable>(key: String) -> T? {
    if let data = defaults.object(forKey: key) as? Data {
      let decoder = JSONDecoder()
      if let object = try? decoder.decode(T.self, from: data) {
        return object
      }
    }
    return nil
  }
}
