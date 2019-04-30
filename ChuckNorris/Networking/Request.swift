//
//  Request.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation

struct Request {
  private let timeoutInterval: TimeInterval = 20
  private let cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy

  private enum HTTPMethod: String {
    case get = "GET"
  }

  private let urlString: String

  init(url: String) {
    urlString = url
  }

  func get<T: Decodable>(params: Params? = nil, completion: @escaping Response<T>) {
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

    let session = URLSession(configuration: URLSessionConfiguration.default)
    let task = session.dataTask(with: urlRequest) { data, response, error in
      DispatchQueue.main.async {
        if let error = error as? URLError {
          switch error.code {
          case .notConnectedToInternet:
            completion(Result.error(ApiError.noInternet))
          default:
            completion(Result.error(ApiError.serverError))
          }
        }

        guard let response = response as? HTTPURLResponse, let data = data else {
          completion(Result.error(ApiError.invalidResponse))
          return
        }

        switch response.statusCode {
        case 200...300:
          let jsonDecoder = JSONDecoder()
          jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
          do {
            let model = try jsonDecoder.decode(T.self, from: data)
            completion(Result.success(model))
          } catch {
            completion(Result.error(ApiError.decodingError))
          }
        default:
          completion(Result.error(ApiError.invalidResponse))
        }
      }
    }
    task.resume()
  }

  // MARK: - Rertry -
  func retry<T: Decodable>(_ attempts: Int = 2,
                task: @escaping (_ success: @escaping (T) -> Void, _ failure: @escaping (ApiError) -> Void) -> Void,
                success: @escaping (T) -> Void,
                failure: @escaping (ApiError) -> Void) {
    task({ obj in
      success(obj)
    }) { err in
      debugPrint("Error retry left \(attempts)")
      if attempts > 0 {
        let deadline: Double = attempts >= 2 ? 4.0 : 8.0
        DispatchQueue.main.asyncAfter(deadline: .now() + deadline, execute: {
          self.retry(attempts - 1, task: task, success: success, failure: failure)
        })
      } else {
        failure(err)
      }
    }
  }
}
