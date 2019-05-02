//
//  Array+Extension.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 29/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

extension Array {
  func getRandomElements(_ total: Int) -> Array {
    return Array(shuffled().prefix(total))
  }
}
