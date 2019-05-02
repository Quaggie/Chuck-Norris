//
//  UICollectionReusableView+Extension.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
  static var identifier: String {
    return String(describing: self)
  }
}
