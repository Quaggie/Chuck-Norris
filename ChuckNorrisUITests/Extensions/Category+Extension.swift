//
//  Category+Extension.swift
//  ChuckNorrisTests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

@testable import ChuckNorris


extension ChuckNorris.Category {
  static func mockCategory() -> ChuckNorris.Category {
    return "Music"
  }

  static func mockCategories(total: Int) -> [ChuckNorris.Category] {
    var categories: [ChuckNorris.Category] = []
    for _ in 0..<total {
      categories.append(mockCategory())
    }
    return categories
  }
}
