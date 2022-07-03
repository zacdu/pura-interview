//
//  SampleAppTests.swift
//  SampleAppTests
//
//  Created by natehancock on 6/28/22.
//

import XCTest
@testable import SampleApp

class SampleAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: Testing Properties
    // shared between multiple tests
    // Try entering different query strings into the various calls to ensure test-failure is happening as expected.
    let emprtyQuery = ""
    let tooShortQuery = "u"
    let validQuery = "umpire"
    
    func testWordResponse() throws {
        let validQueryExpectation = XCTestExpectation(description: #function)
        
        API.shared.fetchWord(query: validQuery) { response in
            switch response {
            case .success(let data):
                if data.isEmpty {
                    XCTFail("data in case of response.success is empty")
                }
                if WordResponse.parseData(data) != nil {
                    validQueryExpectation.fulfill()
                } else {
                    XCTFail("data was not nil, but did not result in a valid WordResponse")
                }
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [validQueryExpectation], timeout: 3.0)
    }

    func testAPIQuery() throws {
        let emptyQueryExpectation = XCTestExpectation(description: #function)
        let tooShortExpectation = XCTestExpectation(description: #function)
        let validQueryExpectation = XCTestExpectation(description: #function)
        
        API.shared.fetchWord(query: emprtyQuery) { response in
            switch response {
            case .success:
                XCTFail("Expected to fail with noQuery")
            case .failure(let error):
                if error != .emptyQuery {
                    XCTFail()
                }
                emptyQueryExpectation.fulfill()
            }
        }

        API.shared.fetchWord(query: tooShortQuery) { response in
            switch response {
            case .success:
                XCTFail("Expected to fail with tooShort '\(self.tooShortQuery)'")
            case .failure(let error):
                if error != .tooShort {
                    XCTFail()
                }
                tooShortExpectation.fulfill()
            }
        }

        API.shared.fetchWord(query: validQuery) { response in
            switch response {
            case .success(let data):
                if data.isEmpty {
                    XCTFail("Expected to succeed with validQuery '\(self.validQuery)'")
                }
                validQueryExpectation.fulfill()
            case .failure:
                XCTFail()
            }
        }
        
        wait(for: [emptyQueryExpectation, tooShortExpectation, validQueryExpectation], timeout: 5.0)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
