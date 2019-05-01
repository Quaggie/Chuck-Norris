//
//  WebserviceSpec.swift
//  ChuckNorrisTests
//
//  Created by Jonathan Bijos on 01/05/19.
//  Copyright © 2019 jonathanbijos. All rights reserved.
//

import Nimble
import Quick
import Mockingjay
@testable import ChuckNorris

struct TestOkModel: Codable {
  let test: String
}

struct TestEmptyModel: Codable {
  let test: [String]
}

extension BaseWebservice {
  static func jsonDataSuccess() -> Data {
    let jsonSuccess: Params = ["test": "ok"]
    return try! JSONSerialization.data(withJSONObject: jsonSuccess)
  }

  static func notJSONDataSuccess() -> Data {
    let string = "test"
    return Data(base64Encoded: string)!
  }

  static func jsonDataEmpty() -> Data {
    let object: [String: Any] = ["test": []]
    return try! JSONSerialization.data(withJSONObject: object)
  }
}

final class WebserviceSpec: QuickSpec {

  override func spec() {
    describe("Test request function") {

      var webservice: BaseWebservice!

      beforeEach {
        webservice = BaseWebservice()
      }

      it("returns success with correct data when receiving 200") {
        self.stub(everything, http(200, headers: nil, download: Download.content(BaseWebservice.jsonDataSuccess())))

        waitUntil { done in
          webservice.request(urlString: "http://www.google.com.br", method: .get, parameters: nil) { (result) in
            switch result {
            case .success(let data):
              let decoder = JSONDecoder()
              guard let testModel = try? decoder.decode(TestOkModel.self, from: data) else {
                XCTFail()
                return
              }
              expect(testModel.test) == "ok"
            case .error:
              XCTFail()
            }
            done()
          }
        }
      }

      it("returns no internet when receiving not connected to internet") {
        let error = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue, userInfo: nil)
        self.stub(everything, failure(error))

        waitUntil { done in
          webservice.request(urlString: "http://www.google.com.br", method: .get, parameters: nil) { (result) in
            switch result {
            case .success:
              XCTFail("This test must be an error")
            case .error(let error):
              expect(error) == ApiError.noInternet
            }
            done()
          }
        }
      }

      it("returns invalid response when there is a bad response") {
        let error = NSError(domain: String(NSURLErrorBadServerResponse), code: URLError.badServerResponse.rawValue, userInfo: nil)
        self.stub(everything, failure(error))

        waitUntil { done in
          webservice.request(urlString: "http://www.google.com.br", method: .get, parameters: nil) { (result) in
            switch result {
            case .success:
              XCTFail("This test must be an error")
            case .error(let error):
              expect(error) == ApiError.invalidResponse
            }
            done()
          }
        }
      }

      it("returns server error when receiving 500") {
        self.stub(everything, http(500, headers: nil, download: nil))

        waitUntil { done in
          webservice.request(urlString: "http://www.google.com.br", method: .get, parameters: nil) { (result) in
            switch result {
            case .success:
              XCTFail("This test must be an error")
            case .error(let error):
              expect(error) == ApiError.serverError
            }
            done()
          }
        }
      }

      it("returns invalid endpoint when URL is invalid") {
        waitUntil { done in
          webservice.request(urlString: "", method: .get, parameters: nil) { (result) in
            switch result {
            case .success:
              XCTFail("This test must be an error")
            case .error(let error):
              expect(error) == ApiError.invalidEndpoint
            }
            done()
          }
        }
      }

      it("returns empty error when receiving an empty response") {
        self.stub(everything, http(200, headers: nil, download: Download.content(BaseWebservice.jsonDataEmpty())))

        waitUntil { done in
          webservice.request(urlString: "http://www.google.com.br", method: .get, parameters: nil) { (result) in
            switch result {
            case .success(let data):
              let decoder = JSONDecoder()
              guard let testModel = try? decoder.decode(TestEmptyModel.self, from: data) else {
                XCTFail()
                return
              }
              expect(testModel.test).to(beEmpty())
            case .error:
              XCTFail()
            }
            done()
          }
        }
      }

      it("returns cancelled response when there is a cancelled response") {
        let error = NSError(domain: String(NSURLErrorCancelled), code: URLError.cancelled.rawValue, userInfo: nil)
        self.stub(everything, failure(error))

        waitUntil { done in
          webservice.request(urlString: "http://www.google.com.br", method: .get, parameters: nil) { (result) in
            switch result {
            case .success:
              XCTFail("This test must be an error")
            case .error(let error):
              expect(error) == ApiError.cancelled
            }
            done()
          }
        }
      }

    }
  }
}

