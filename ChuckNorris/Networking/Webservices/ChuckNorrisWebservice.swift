//
//  ChuckNorrisWebservice.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation

protocol ChuckNorrisWebserviceProtocol: AnyObject {
  func getCategories(completion: @escaping (Result<[Category]>) -> Void)
  func getJokesBySearching(query: String, completion: @escaping (Result<JokesSearchResponse>) -> Void)
}

final class ChuckNorrisWebservice: ChuckNorrisWebserviceProtocol {
  private let service: Webservice

  init(service: Webservice = BaseWebservice()) {
    self.service = service
  }

  deinit {
    debugPrint("Deinit ChuckNorrisWebservice")
    service.cancelAllRequests()
  }

  func getCategories(completion: @escaping (Result<[Category]>) -> Void) {
    service.retry(2, task: { [weak self] (successCompletion, errorCompletion) in
      self?.service.request(urlString: Endpoints.jokes.categories.value, method: .get, parameters: nil, completion: { (result) in
        switch result {
        case .success(let data):
          let jsonDecoder = JSONDecoder()
          jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let response = try jsonDecoder.decode([Category].self, from: data)
            successCompletion(response)
          } catch {
            errorCompletion(.decodingError)
          }
        case .error(let err):
          errorCompletion(err)
        }
      })
    }, success: { (response: [Category]) in
      completion(.success(response))
    }) { (err) in
      completion(.error(err))
    }
  }

  func getJokesBySearching(query: String, completion: @escaping (Result<JokesSearchResponse>) -> Void) {

    let params: Params = ["query": query]

    service.retry(2, task: { [weak self] (successCompletion, errorCompletion) in
      self?.service.request(urlString: Endpoints.jokes.search.value, method: .get, parameters: params, completion: { (result) in
        switch result {
        case .success(let data):
          let jsonDecoder = JSONDecoder()
          jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let response = try jsonDecoder.decode(JokesSearchResponse.self, from: data)
            if response.total == 0 {
              errorCompletion(.empty)
            } else {
              successCompletion(response)
            }
          } catch {
            completion(.error(.decodingError))
          }
        case .error(let err):
          errorCompletion(err)
        }
      })
    }, success: { (response: JokesSearchResponse) in
      completion(.success(response))
    }) { (err) in
      completion(.error(err))
    }
  }
}
