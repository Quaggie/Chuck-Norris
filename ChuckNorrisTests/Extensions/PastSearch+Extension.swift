//
//  PastSearch+Extension.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation
@testable import ChuckNorris

extension PastSearch {
  static func mockPastSearches(total: Int) -> [PastSearch] {
    var pastSearches: [PastSearch] = []
    for index in 0..<total {
      let pastSearch = PastSearch(text: "Search\(index)")
      pastSearch.dateAdded = Date(timeIntervalSince1970: Double(index))
      pastSearches.append(pastSearch)
    }
    return pastSearches
  }
}
