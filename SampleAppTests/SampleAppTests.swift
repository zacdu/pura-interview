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

    func testExample() throws {
        // Try entering different query strings into the various calls to ensure failure is happening as expected.
        let emprtyQuery = ""
        let tooShortQuery = "u"
        let validQuery = "umpire"
        
        let emptyQueryExpectation = XCTestExpectation(description: #function)
        let tooShortExpectation = XCTestExpectation(description: #function)
        let validQueryExpectation = XCTestExpectation(description: #function)
        
        API.shared.fetchWord(query: emprtyQuery) { response in
            // Here, we expect to failure, so guarding against success
            if case .success = response {
                XCTFail("Expected to fail with noQuery")
            }
            
            switch response {
            case .success:
                XCTFail()
            case .failure(let error):
                if error != .emptyQuery {
                    XCTFail()
                }
                emptyQueryExpectation.fulfill()
            }
        }

        API.shared.fetchWord(query: tooShortQuery) { response in
            if case .success = response {
                XCTFail("Expected to fail with tooShort '\(tooShortQuery)'")
            }
            
            switch response {
            case .success:
                XCTFail()
            case .failure(let error):
                if error != .tooShort {
                    XCTFail()
                }
                tooShortExpectation.fulfill()
            }
        }

        API.shared.fetchWord(query: validQuery) { response in
            if case .failure = response {
                XCTFail("Expected to succeed with validQuery '\(validQuery)'")
            }
            
            switch response {
            case .success(let data):
                if data.isEmpty {
                    XCTFail()
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
