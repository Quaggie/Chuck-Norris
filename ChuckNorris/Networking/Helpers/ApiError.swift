//
//  ApiError.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

enum ApiError {
  case noInternet
  case serverError
  case decodingError
  case invalidResponse
  case invalidEndpoint
}
