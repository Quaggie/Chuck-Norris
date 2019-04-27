//
//  FactsDataSourceSpec.swift
//  ChuckNorrisTests
//
//  Created by jonathan.p.bijos on 26/04/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Quick
import Nimble
@testable import ChuckNorris

final class FactsDataSourceSpec: QuickSpec {
  override func spec() {
    describe("FactsDataSource") {
      var sut: FactsDataSource!
      var collectionView: UICollectionView!
      var jokes: [Joke] = []
      let delegate = FakeCellDelegate()

      beforeEach {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        jokes = Joke.mockJokes(total: 2)
        sut = FactsDataSource(collectionView: collectionView, delegate: delegate, jokes: jokes)
      }

      context("When instantiated") {
        it("should have the correct number of jokes") {
          let items = sut.collectionView(collectionView, numberOfItemsInSection: 0)
          expect(items).to(equal(2))
        }

        it("should return the correctly number of initial and final portion") {
          let firstIndexPath = IndexPath(item: 0, section: 0)
          let cell = sut.collectionView(collectionView, cellForItemAt: firstIndexPath)
          expect(cell).to(beAKindOf(FactsCollectionViewCell.self))
        }
      }
    }
  }
}

fileprivate final class FakeCellDelegate: FactsCollectionViewCellDelegate {
  func factsCollectionViewCellDidTapShare(joke: Joke) {

  }
}
