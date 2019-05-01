//
//  FakeChuckNorrisWebservice.swift
//  ChuckNorrisUITests
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

@testable import ChuckNorris

enum FakeChuckNorrisWebserviceCategoryResponseType {
  case loading
  case success
  case error(ApiError)
}

enum FakeChuckNorrisWebserviceSearchResponseType {
  case loading
  case success
  case error(ApiError)
}

final class FakeChuckNorrisWebservice: ChuckNorrisWebserviceProtocol {
  private let categoryResponseType: FakeChuckNorrisWebserviceCategoryResponseType
  private let searchResponseType: FakeChuckNorrisWebserviceSearchResponseType

  init(categoryResponseType: FakeChuckNorrisWebserviceCategoryResponseType,
       searchResponseType: FakeChuckNorrisWebserviceSearchResponseType) {
    self.categoryResponseType = categoryResponseType
    self.searchResponseType = searchResponseType
  }

  func getCategories(completion: @escaping (Result<[ChuckNorris.Category]>) -> Void) {
    switch categoryResponseType {
    case .loading:
      break
    case .success:
      completion(.success(ChuckNorris.Category.mockCategories(total: 15)))
    case .error(let error):
      completion(.error(error))
    }
  }

  func getJokesBySearching(query: String, completion: @escaping (Result<JokesSearchResponse>) -> ()) {
    switch searchResponseType {
    case .loading:
      break
    case .success:
      completion(.success(JokesSearchResponse.mock(totalJokes: 15)))
    case .error(let error):
      completion(.error(error))
    }
  }
}
