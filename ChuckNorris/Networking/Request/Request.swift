//
//  Request.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation

final class Request: WebserviceRequestProtocol {
  // MARK: - Public properties -
  var task: URLSessionTask?

  // MARK: - Private properties -
  private let timeoutInterval: TimeInterval = 20
  private let cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
  private let urlString: String
  private let session = URLSession(configuration: URLSessionConfiguration.default)

  // MARK: - Init -
  init(url: String) {
    urlString = url
  }

  deinit {
    debugPrint("Deinit Request")
  }

  // MARK: - Public functions -
  func get(params: Params? = nil, completion: @escaping Response) {
    var urlComponents = URLComponents(string: urlString)
    var items: [URLQueryItem] = []
    if let params = params {
      for (key,value) in params {
        items.append(URLQueryItem(name: key, value: value))
      }
    }
    items = items.filter({ !$0.name.isEmpty })
    if !items.isEmpty {
      urlComponents?.queryItems = items
    }
    guard let url = urlComponents?.url else {
      completion(Result.error(ApiError.invalidEndpoint))
      return
    }

    var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    urlRequest.httpMethod = HTTPMethod.get.rawValue

    task = session.dataTask(with: urlRequest) { data, response, error in
      DispatchQueue.main.async {
        if let error = error as? URLError {
          switch error.code {
          case .notConnectedToInternet:
            completion(Result.error(ApiError.noInternet))
          case .cancelled:
            completion(Result.error(ApiError.cancelled))
          default:
            completion(Result.error(ApiError.serverError))
          }
          return
        }

        guard let response = response as? HTTPURLResponse, let data = data else {
          completion(Result.error(ApiError.invalidResponse))
          return
        }

        switch response.statusCode {
        case 200...300:
          completion(.success(data))
        default:
          completion(Result.error(ApiError.serverError))
        }
      }
    }
    task?.resume()
  }

  func cancel() {
    task?.cancel()
  }
}
