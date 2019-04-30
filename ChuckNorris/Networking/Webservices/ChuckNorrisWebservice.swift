//
//  ChuckNorrisWebservice.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

protocol ChuckNorrisWebserviceProtocol {
  func getCategories(completion: @escaping Response<[Category]>)
  func getJokesBySearching(query: String, completion: @escaping Response<JokesSearchResponse>)
}

struct ChuckNorrisWebservice: ChuckNorrisWebserviceProtocol {
  func getCategories(completion: @escaping Response<[Category]>) {
    let request = Request(url: Endpoints.jokes.categories.value)

    request.retry(task: { (successCompletion, errorCompletion) in
      request.get { (result: Result<[Category]>) in
        switch result {
        case .success(let response):
          successCompletion(response)
        case .error(let err):
          errorCompletion(err)
        }
      }
    }, success: { (response: [Category]) in
      completion(.success(response))
    }) { (err) in
      completion(.error(err))
    }
  }

  func getJokesBySearching(query: String, completion: @escaping Response<JokesSearchResponse>) {
    let request = Request(url: Endpoints.jokes.search.value)
    let params: Params = ["query": query]

    request.retry(task: { (successCompletion, errorCompletion) in
      request.get(params: params) { (result: Result<JokesSearchResponse>) in
        switch result {
        case .success(let response):
          if response.total == 0 {
            errorCompletion(.empty)
          } else {
            successCompletion(response)
          }
          successCompletion(response)
        case .error(let err):
          errorCompletion(err)
        }
      }
    }, success: { (response: JokesSearchResponse) in
      completion(.success(response))
    }) { (err) in
      completion(.error(err))
    }
  }
}
