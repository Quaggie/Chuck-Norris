//
//  FakeChuckNorrisWebservice.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

@testable import ChuckNorris

enum FakeChuckNorrisWebserviceResponseType {
  case loading
  case success
  case error(ApiError)
}

final class FakeChuckNorrisWebservice: ChuckNorrisWebserviceProtocol {
  private let responseType: FakeChuckNorrisWebserviceResponseType

  init(responseType: FakeChuckNorrisWebserviceResponseType) {
    self.responseType = responseType
  }

  func getCategories(completion: @escaping (Result<[ChuckNorris.Category]>) -> Void) {
    switch responseType {
    case .loading:
      break
    case .success:
      completion(.success(ChuckNorris.Category.mockCategories(total: 10)))
    case .error(let error):
      completion(.error(error))
    }
  }

  func getJokesBySearching(query: String, completion: @escaping (Result<JokesSearchResponse>) -> ()) {
    switch responseType {
    case .loading:
      break
    case .success:
      completion(.success(JokesSearchResponse.mock(totalJokes: 5)))
    case .error(let error):
      completion(.error(error))
    }
  }
}
