//
//  PastSearch+Extension.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

@testable import ChuckNorris

extension PastSearch {
  static func mockPastSearches(total: Int) -> [PastSearch] {
    var pastSearches: [PastSearch] = []
    for index in 0..<total {
      pastSearches.append(PastSearch(text: "Search\(index)"))
    }
    return pastSearches
  }
}
