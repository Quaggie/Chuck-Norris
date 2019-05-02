//
//  ChuckNorrisWebserviceSpec.swift
//  ChuckNorrisTests
//
//  Created by jonathan.p.bijos on 02/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Quick
import Nimble
@testable import ChuckNorris

final class ChuckNorrisWebserviceSpec: QuickSpec {

  final private class Service: Webservice {
    var requests: [Int] = []
    func request(urlString: String, method: HTTPMethod, parameters: Params?, completion: @escaping (Result<Data>) -> Void) {
      requests.append(0)
      if urlString == Endpoints.jokes.categories.value {
        let model = ["Music"]
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model)
        completion(.success(data))
      } else if urlString == Endpoints.jokes.search.value {
        let model = JokesSearchResponse(total: 1, result: [Joke.mockJoke()])
        let encoder = JSONEncoder()
        let data = try! encoder.encode(model)
        completion(.success(data))
      } else {
        completion(.error(.invalidEndpoint))
      }
    }

    func cancelAllRequests() {
      requests = []
    }

    func retry<T>(_ attempts: Int, task: @escaping (@escaping (T) -> Void, @escaping (ApiError) -> Void) -> Void, success: @escaping (T) -> Void, failure: @escaping (ApiError) -> Void) where T : Decodable {
      task({ obj in
        success(obj)
      }) { err in
        failure(err)
      }
    }
  }

  override func spec() {
    describe("ChuckNorrisWebserviceSpec") {
      var sut: ChuckNorrisWebserviceProtocol!
      var service: Webservice!

      beforeEach {
        service = Service()
        sut = ChuckNorrisWebservice(service: service)
      }

      context("On requesting") {
        it("should return the correct number of categories") {
          service.cancelAllRequests()
          waitUntil { done in
            sut.getCategories { (result) in
              switch result {
              case .success(let response):
                expect(response.count).to(equal(1))
                done()
              case .error:
                XCTFail("This test is meant to be a success")
              }
            }
          }
        }

        it("should return the correct number of jokes") {
          service.cancelAllRequests()
          waitUntil { done in
            sut.getJokesBySearching(query: "") { (result) in
              switch result {
              case .success(let response):
                expect(response.total).to(equal(1))
                done()
              case .error:
                XCTFail("This test is meant to be a success")
              }
            }
          }
        }

      }

    }
  }
}
