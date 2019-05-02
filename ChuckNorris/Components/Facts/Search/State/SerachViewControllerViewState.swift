//
//  SerachViewControllerViewState.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

enum SearchViewControllerViewState: Equatable {
  case initial
  case loading
  case finished
  case error(ApiError)
}
