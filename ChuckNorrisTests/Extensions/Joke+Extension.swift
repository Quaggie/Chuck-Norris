//
//  Joke+Extension.swift
//  ChuckNorrisTests
//
//  Created by jonathan.p.bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

@testable import ChuckNorris

extension Joke {
  static func mockJoke() -> Joke {
    return Joke(category: nil,
                iconUrl: "https://assets.chucknorris.host/img/avatar/chuck-norris.png",
                id: "qnms6dwpsb6gkiuknbdwfw",
                url: "https://api.chucknorris.io/jokes/qnms6dwpsb6gkiuknbdwfw",
                value: "If at first you don't succeed, you're not Chuck Norris.")
  }

  static func mockJokes(total: Int) -> [Joke] {
    var jokes: [Joke] = []
    for _ in 0..<total {
      jokes.append(mockJoke())
    }
    return jokes
  }
}
