//
//  ChuckNorrisWebservice.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

protocol ChuckNorrisWebserviceProtocol {
  func getCategories(completion: @escaping Response<[Category]>)
  func getRandomJoke(category: String?, completion: @escaping Response<Joke>)
  func getJokesBySearching(query: String, completion: @escaping Response<JokesSearchResponse>)
}

struct ChuckNorrisWebservice: ChuckNorrisWebserviceProtocol {
  func getCategories(completion: @escaping Response<[Category]>) {
    let request = Request(url: Endpoints.jokes.categories.value)

    request.get { (result: Result<[Category]>) in
      switch result {
      case .success(let response):
        completion(.success(response))
      case .error(let err):
        completion(.error(err))
      }
    }
  }

  func getRandomJoke(category: String? = nil, completion: @escaping Response<Joke>) {
    let request = Request(url: Endpoints.jokes.random.value)
    var params: Params = [:]
    if let category = category {
      params["category"] = category
    }

    request.get(params: params) { (result: Result<Joke>) in
      switch result {
      case .success(let response):
        completion(.success(response))
      case .error(let err):
        completion(.error(err))
      }
    }
  }

  func getJokesBySearching(query: String, completion: @escaping Response<JokesSearchResponse>) {
    let request = Request(url: Endpoints.jokes.search.value)
    let params: Params = ["query": query]

    request.get(params: params) { (result: Result<JokesSearchResponse>) in
      switch result {
      case .success(let response):
        if response.total == 0 {
          completion(.error(.empty))
        } else {
          completion(.success(response))
        }
      case .error(let err):
        completion(.error(err))
      }
    }
  }
}
