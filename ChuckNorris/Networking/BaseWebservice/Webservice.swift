//
//  Webservice.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 30/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Foundation

protocol Webservice {
  func request(urlString: String, method: HTTPMethod, parameters: Params?, completion: @escaping (Result<Data>) -> Void)
  func cancelAllRequests()
  func retry<T: Decodable>(_ attempts: Int,
                           task: @escaping (_ success: @escaping (T) -> Void, _ failure: @escaping (ApiError) -> Void) -> Void,
                           success: @escaping (T) -> Void,
                           failure: @escaping (ApiError) -> Void)
}
