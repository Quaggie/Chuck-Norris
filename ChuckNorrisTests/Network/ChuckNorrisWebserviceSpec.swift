//
//  ChuckNorrisWebserviceSpec.swift
//  ChuckNorrisTests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//


import Quick
import Nimble
@testable import ChuckNorris

final class WebserviceAutoRetrySpec: QuickSpec {
  override func spec() {
    describe("Database") {
      var sut: BaseWebservice!

      beforeEach {
        sut = BaseWebservice()
      }

      context("When Retrying") {
        it("should retry 2 times when there was an error") {
          var counter: Int = 0

          waitUntil(timeout: 13) { (done) in
            sut.retry(2, task: { (successCompletion, errorCompletion) in
              counter += 1
              errorCompletion(.serverError)
            }, success: { (result: Int) in
              XCTFail("This test should throw an error")
            }, failure: { (error) in
              expect(counter).to(equal(3))
              done()
            })
          }
        }

        it("should retry 1 time only if there is a success on the first retry") {
          var counter: Int = 0

          waitUntil(timeout: 5) { (done) in
            sut.retry(2, task: { (successCompletion, errorCompletion) in
              counter += 1
              if counter == 2 {
                successCompletion(counter)
              } else {
                errorCompletion(.serverError)
              }
            }, success: { (result: Int) in
              expect(counter).to(equal(2))
              done()
            }, failure: { (error) in
              XCTFail("This test be a success")
            })
          }
        }

        it("should not retry if the request was a success on the first try") {
          var counter: Int = 0

          waitUntil { (done) in
            sut.retry(2, task: { (successCompletion, errorCompletion) in
              counter += 1
              successCompletion(counter)
            }, success: { (result: Int) in
              expect(counter).to(equal(1))
              done()
            }, failure: { (error) in
              XCTFail("This test be a success")
            })
          }
        }

      }
    }
  }
}
