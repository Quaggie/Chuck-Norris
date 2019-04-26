//
//  UIView+Extension.swift
//  ChuckNorris
//
//  Created by Jonathan Bijos on 25/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import UIKit

typealias NSLayoutDimensionHeightAndWidth = (NSLayoutConstraint?, NSLayoutConstraint?)
typealias NSLayoutConstraintXAndY = (NSLayoutConstraint?, NSLayoutConstraint?)

// MARK: - Constraints -
extension UIView {
  func fillSuperview() {
    anchor(top: superview?.topAnchor,
           leading: superview?.leadingAnchor,
           bottom: superview?.bottomAnchor,
           trailing: superview?.trailingAnchor)
  }
  
  @discardableResult
  func anchor(top: NSLayoutYAxisAnchor? = nil,
              leading: NSLayoutXAxisAnchor? = nil,
              bottom: NSLayoutYAxisAnchor? = nil,
              trailing: NSLayoutXAxisAnchor? = nil,
              insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
    translatesAutoresizingMaskIntoConstraints = false

    var anchors = [NSLayoutConstraint]()

    if let top = top {
      anchors.append(topAnchor.constraint(equalTo: top, constant: insets.top))
    }

    if let leading = leading {
      anchors.append(leadingAnchor.constraint(equalTo: leading, constant: insets.left))
    }

    if let bottom = bottom {
      anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -insets.bottom))
    }

    if let trailing = trailing {
      anchors.append(trailingAnchor.constraint(equalTo: trailing, constant: -insets.right))
    }

    NSLayoutConstraint.activate(anchors)

    return anchors
  }

  @discardableResult
  func anchor(height: CGFloat? = nil, width: CGFloat? = nil) -> [NSLayoutConstraint] {
    translatesAutoresizingMaskIntoConstraints = false

    var anchors = [NSLayoutConstraint]()

    if let height = height {
      anchors.append(heightAnchor.constraint(equalToConstant: height))
    }

    if let width = width {
      anchors.append(widthAnchor.constraint(equalToConstant: width))
    }

    NSLayoutConstraint.activate(anchors)

    return anchors
  }

  @discardableResult
  func anchor(heightAnchor: NSLayoutDimension? = nil,
              heightMultiplier: CGFloat = 1,
              widthAnchor: NSLayoutDimension? = nil,
              widthMultiplier: CGFloat = 1) -> NSLayoutDimensionHeightAndWidth {
    translatesAutoresizingMaskIntoConstraints = false

    var heightConstraint: NSLayoutConstraint?
    var widthConstraint: NSLayoutConstraint?

    if let heightAnchor = heightAnchor {
      heightConstraint = self.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier)
      heightConstraint?.isActive = true
    }

    if let widthAnchor = widthAnchor {
      widthConstraint = self.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier)
      widthConstraint?.isActive = true
    }

    return (heightConstraint, widthConstraint)
  }

  @discardableResult
  func anchorCenterXToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint? {
    translatesAutoresizingMaskIntoConstraints = false

    if let centerXAnchor = superview?.centerXAnchor {
      let anchor = self.centerXAnchor.constraint(equalTo: centerXAnchor, constant: constant)
      anchor.isActive = true
      return anchor
    }

    return nil
  }

  @discardableResult
  func anchorCenterYToSuperview(constant: CGFloat = 0) -> NSLayoutConstraint? {
    translatesAutoresizingMaskIntoConstraints = false

    if let centerYAnchor = superview?.centerYAnchor {
      let anchor = self.centerYAnchor.constraint(equalTo: centerYAnchor, constant: constant)
      anchor.isActive = true
      return anchor
    }

    return nil
  }

  @discardableResult
  func anchorCenterSuperview() -> NSLayoutConstraintXAndY {
    let centerXAnchor = anchorCenterXToSuperview()
    let centerYAnchor = anchorCenterYToSuperview()

    return (centerXAnchor, centerYAnchor)
  }
}

// MARKL - Shadow -
extension UIView {
  func applyShadow(color: UIColor,
                   offset: CGSize = CGSize(width: 0.0, height: 2.0),
                   opacity: Float = 0.2,
                   radius: CGFloat = 1.0) {
    layer.shadowColor = color.cgColor
    layer.shadowOffset = offset
    layer.shadowRadius = radius
    layer.shadowOpacity = Float(opacity)
    layer.masksToBounds = false
  }
}
