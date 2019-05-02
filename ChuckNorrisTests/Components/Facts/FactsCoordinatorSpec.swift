//
//  FactsCoordinatorSpec.swift
//  ChuckNorrisTests
//
//  Created by jonathan.p.bijos on 02/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Quick
import Nimble
@testable import ChuckNorris

final class FactsCoordinatorSpec: QuickSpec {
  override func spec() {
    describe("FactsCoordinatorSpec") {
      var sut: FactsCoordinator!
      var navigationController: UINavigationController!

      beforeEach {
        navigationController = UINavigationController()
        sut = FactsCoordinator(navigationController: navigationController)
        sut.start()
      }

      context("On init") {
        it("should only have 1 viewController") {
          expect(navigationController.viewControllers.count).to(equal(1))
        }

        it("should have factsViewController as the visible viewController") {
          expect(navigationController.visibleViewController).to(beAKindOf(FactsViewController.self))
        }
      }

      context("On navigating to SearchViewController") {
        beforeEach {

        }

        it("should have 2 viewControllers") {
          sut.goToSearch()
          // Needed for animations
          waitUntil { (done) in
            expect(navigationController.viewControllers.count).to(equal(2))
            done()
          }
        }

        it("should have SearchViewController as the visible viewController") {
          sut.goToSearch()
          // Needed for animations
          waitUntil { (done) in
            expect(navigationController.visibleViewController).to(beAKindOf(SearchViewController.self))
            done()
          }
        }
      }
    }
  }
}

