//
//  FactsViewControllerViewState.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

enum FactsViewControllerViewState: Equatable {
  case loading
  case finished
  case empty
  case error(ApiError)
}
