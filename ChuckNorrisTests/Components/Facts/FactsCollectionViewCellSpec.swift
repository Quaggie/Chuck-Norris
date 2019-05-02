//
//  FactsCollectionViewCellSpec.swift
//  ChuckNorrisTests
//
//  Created by jonathan.p.bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Quick
import Nimble
@testable import ChuckNorris

final class FactsCollectionViewCellSpec: QuickSpec {
  override func spec() {
    describe("FactsCollectionViewCell") {
      var textWithLessThan80Characters: String!
      var textWithMoreThan80Characters: String!

      beforeEach {
        textWithLessThan80Characters = "Chuck Norris"
        textWithMoreThan80Characters = "There's an order to the universe: space, time, Chuck Norris.... Just kidding, Chuck Norris is first."
      }

      context("When receiving a joke with only a few characters") {
        it("should have a big font size") {
          let fontSize = FactsCollectionViewCell.getFontSize(from: textWithLessThan80Characters)
          expect(fontSize).to(equal(28))
        }
      }

      context("When receiving a joke with a lot of characters") {
        it("should have a small font size") {
          let fontSize = FactsCollectionViewCell.getFontSize(from: textWithMoreThan80Characters)
          expect(fontSize).to(equal(UIFont.smallSystemFontSize))
        }
      }

      context("When receiving a joke with a category") {
        it("should display an uppercased category on the card") {
          let category = FactsCollectionViewCell.getCorrectCategory(from: ["music"])
          expect(category).to(equal("MUSIC"))
        }
      }

      context("When receiving a joke with no category") {
        it("should display an uppercased category on the card") {
          let category = FactsCollectionViewCell.getCorrectCategory(from: nil)
          expect(category).to(equal("UNCATEGORIZED"))
        }
      }
    }
  }
}
