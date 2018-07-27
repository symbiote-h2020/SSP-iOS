//
//  SecuritySSPTests.swift
//  SecuritySSPTests
//
//  Created by Konrad Leszczyński on 25/07/2018.
//  Copyright © 2018 Konrad. All rights reserved.
//

//zupa zupa

import XCTest
@testable import SecuritySSP

class SecuritySSPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetAams() {
        GuestTokensManager.shared.getAvailableAams()
        
        if waitForNotificationNamed(SymNotificationName.CoreCommunictation.rawValue) {
            XCTAssertTrue(GuestTokensManager.shared.aams.count >= 1 , "There are some AAMs")
        }
    }
    
    func waitForNotificationNamed(_ notificationName: String) -> Bool {
        let expectation = XCTNSNotificationExpectation(name: notificationName)
        let result = XCTWaiter().wait(for: [expectation], timeout: 5)
        log("waitForNotificationNamed result = \(result.rawValue)")
        return result == .completed
    }
    
}
