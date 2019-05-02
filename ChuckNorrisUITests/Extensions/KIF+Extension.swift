//
//  KIF+Extension.swift
//  ChuckNorrisUITests
//
//  Created by jonathan.p.bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

// Code necessary for KIF to work properly in Swift
extension XCTestCase {
  var tester: KIFUITestActor { return tester() }
  var system: KIFSystemTestActor { return system() }

  private func tester(_ file: String = #file, _ line: Int = #line) -> KIFUITestActor {
    return KIFUITestActor(inFile: file, atLine: line, delegate: self)
  }

  private func system(_ file: String = #file, _ line: Int = #line) -> KIFSystemTestActor {
    return KIFSystemTestActor(inFile: file, atLine: line, delegate: self)
  }
}
