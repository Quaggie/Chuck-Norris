//
//  JokesSearchResponse+Extension.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

@testable import ChuckNorris

extension JokesSearchResponse {
  static func mock(totalJokes: Int) -> JokesSearchResponse {
    return JokesSearchResponse(total: totalJokes, result: Joke.mockJokes(total: totalJokes))
  }
}
