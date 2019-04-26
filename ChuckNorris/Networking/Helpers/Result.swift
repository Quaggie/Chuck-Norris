//
//  Result.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

enum Result<T> {
  case success(T)
  case error(ApiError)
}
