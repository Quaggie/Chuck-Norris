//
//  Joke.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

struct Joke: Codable {
  var category: [String]?
  let iconUrl: String
  let id: String
  let url: String
  let value: String
}
