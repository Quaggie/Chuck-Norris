//
//  PastSearch.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 29/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation

final class PastSearch: Codable {
  let text: String
  var dateAdded = Date()

  init(text: String) {
    self.text = text
  }
}

extension PastSearch: Equatable {
  static func ==(lhs: PastSearch, rhs: PastSearch) -> Bool {
    return lhs.text == rhs.text
  }
}
