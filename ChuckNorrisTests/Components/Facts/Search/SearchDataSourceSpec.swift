//
//  SearchDataSourceSpec.swift
//  ChuckNorrisTests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Quick
import Nimble
@testable import ChuckNorris

final class SearchDataSourceSpec: QuickSpec {
  override func spec() {
    describe("SearchDataSource") {
      var sut: SearchDataSource!
      var collectionView: UICollectionView!
      var types: [SearchDataSourceType] = []

      beforeEach {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        types = [.sectionTitle(.suggestions),
                 .categories(["Music"]),
                 .sectionTitle(.pastSearches),
                 .pastSearches([PastSearch(text: "Search0")])]
        sut = SearchDataSource(collectionView: collectionView, types: types)
      }

      context("When showing suggestions section title") {
        it("should have the correct number of items") {
          let index = types.firstIndex(where: { (type) -> Bool in
            switch type {
            case .sectionTitle(let titleType):
              return titleType == .suggestions
            default:
              return false
            }
          })
          guard let section = index else {
            XCTFail("No section found")
            return
          }

          let items = sut.collectionView(collectionView, numberOfItemsInSection: section)
          expect(items).to(equal(1))
        }

        it("should have the correct cell type") {
          let index = types.firstIndex(where: { (type) -> Bool in
            switch type {
            case .sectionTitle(let titleType):
              return titleType == .suggestions
            default:
              return false
            }
          })
          guard let section = index else {
            XCTFail("No section found")
            return
          }
          let indexPath = IndexPath(item: 0, section: section)
          let cell = sut.collectionView(collectionView, cellForItemAt: indexPath)
          expect(cell).to(beAKindOf(SearchTitleCollectionViewCell.self))
        }
      }

      context("When showing suggestions chips") {
        it("should have the correct number of items") {
          let tuple = types.enumerated().first(where: { (index, element) -> Bool in
            switch element {
            case .categories:
              return true
            default:
              return false
            }
          })

          guard let section = tuple?.offset, let type = tuple?.element else {
            XCTFail("No section found")
            return
          }
          var categories: [ChuckNorris.Category] = []
          switch type {
          case .categories(let _categories):
            categories = _categories
          default:
            break
          }

          let items = sut.collectionView(collectionView, numberOfItemsInSection: section)
          expect(items).to(equal(categories.count))
        }

        it("should have the correct cell type") {
          let index = types.firstIndex(where: { (type) -> Bool in
            switch type {
            case .categories:
              return true
            default:
              return false
            }
          })
          guard let section = index else {
            XCTFail("No section found")
            return
          }
          let indexPath = IndexPath(item: 0, section: section)
          let cell = sut.collectionView(collectionView, cellForItemAt: indexPath)
          expect(cell).to(beAKindOf(SearchSuggestionCollectionViewCell.self))
        }
      }

      context("When showing pastSearch section title") {
        it("should have the correct number of items") {
          let index = types.firstIndex(where: { (type) -> Bool in
            switch type {
            case .sectionTitle(let titleType):
              return titleType == .pastSearches
            default:
              return false
            }
          })
          guard let section = index else {
            XCTFail("No section found")
            return
          }

          let items = sut.collectionView(collectionView, numberOfItemsInSection: section)
          expect(items).to(equal(1))
        }

        it("should have the correct cell type") {
          let index = types.firstIndex(where: { (type) -> Bool in
            switch type {
            case .sectionTitle(let titleType):
              return titleType == .pastSearches
            default:
              return false
            }
          })
          guard let section = index else {
            XCTFail("No section found")
            return
          }
          let indexPath = IndexPath(item: 0, section: section)
          let cell = sut.collectionView(collectionView, cellForItemAt: indexPath)
          expect(cell).to(beAKindOf(SearchTitleCollectionViewCell.self))
        }
      }

      context("When showing pastSearch results") {
        it("should have the correct number of items") {
          let tuple = types.enumerated().first(where: { (index, element) -> Bool in
            switch element {
            case .pastSearches:
              return true
            default:
              return false
            }
          })

          guard let section = tuple?.offset, let type = tuple?.element else {
            XCTFail("No section found")
            return
          }
          var pastSearches: [PastSearch] = []
          switch type {
          case .pastSearches(let _pastSearches):
            pastSearches = _pastSearches
          default:
            break
          }

          let items = sut.collectionView(collectionView, numberOfItemsInSection: section)
          expect(items).to(equal(pastSearches.count))
        }

        it("should have the correct cell type") {
          let index = types.firstIndex(where: { (type) -> Bool in
            switch type {
            case .pastSearches:
              return true
            default:
              return false
            }
          })
          guard let section = index else {
            XCTFail("No section found")
            return
          }
          let indexPath = IndexPath(item: 0, section: section)
          let cell = sut.collectionView(collectionView, cellForItemAt: indexPath)
          expect(cell).to(beAKindOf(SearchPastSearchCollectionViewCell.self))
        }
      }

      context("When instantiated") {
        it("should have the correct number of sections") {
          let sections = sut.numberOfSections(in: collectionView)
          expect(sections).to(equal(types.count))
        }
      }

    }
  }
}
