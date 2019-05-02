//
//  TextSearchResponse.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

struct JokesSearchResponse: Codable {
  let total: Int
  let result: [Joke]
}
