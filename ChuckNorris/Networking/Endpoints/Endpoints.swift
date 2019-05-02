//
//  Endpoints.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

private protocol Endpoint {
  var endpoint: String { get }
  var value: String { get }
}

enum Endpoints {
  private static let baseUrl = "https://api.chucknorris.io"

  enum jokes: Endpoint {
    var endpoint: String { return "jokes" }
    case categories
    case search

    var value: String {
      switch self {
      case .categories:
        return "\(Endpoints.baseUrl)/\(endpoint)/categories"
      case .search:
        return "\(Endpoints.baseUrl)/\(endpoint)/search"
      }
    }
  }
}

