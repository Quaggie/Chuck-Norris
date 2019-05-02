//
//  DatabaseSpec.swift
//  ChuckNorrisTests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Quick
import Nimble
@testable import ChuckNorris

final class DatabaseSpec: QuickSpec {
  override func spec() {
    describe("Database") {
      var sut: Database!

      beforeEach {
        sut = Database(defaults: UserDefaults(suiteName: "FakeUnitTestUserDefaults")!)
      }

      context("On saving Jokes") {
        it("should have the correct number of jokes when retrieving jokes") {
          let jokes = Joke.mockJokes(total: 20)
          sut.save(object: jokes, forKey: .facts)
          let savedJokes: [Joke] = sut.getObject(key: .facts) ?? []
          expect(savedJokes.count).to(equal(jokes.count))
        }
      }

      context("On saving Categories") {
        it("should have the correct number of categories when retrieving categories") {
          let categories = ChuckNorris.Category.mockCategories(total: 20)
          sut.save(object: categories, forKey: .categories)
          let savedCategories: [ChuckNorris.Category] = sut.getObject(key: .categories) ?? []
          expect(savedCategories.count).to(equal(categories.count))
        }
      }

      context("On saving PastSearches") {
        it("should have the correct number of pastSearches when retrieving 5 or less pastSearches") {
          let pastSearches = PastSearch.mockPastSearches(total: 5)
          pastSearches.forEach({ (obj) in
            sut.save(object: obj, forKey: .pastSearches)
          })
          let savedPastSearches: [PastSearch] = sut.getObject(key: .pastSearches) ?? []
          expect(pastSearches.count).to(equal(savedPastSearches.count))
        }

        it("should have 5 pastSearches when saving 6 or more pastSearches") {
          let pastSearches = PastSearch.mockPastSearches(total: 10)
          pastSearches.forEach({ (obj) in
            sut.save(object: obj, forKey: .pastSearches)
          })
          let savedPastSearches: [PastSearch] = sut.getObject(key: .pastSearches) ?? []
          expect(savedPastSearches.count).to(equal(5))
        }
      }

    }
  }
}
