//
//  AndroidLikeTests.swift
//  SSPAppTests
//
//  Created by Konrad Leszczyński on 06/08/2018.
//  Copyright © 2018 PSNC. All rights reserved.
//

import XCTest
@testable import SecuritySSP


/**
 This test are suposed to run like its android counterpart
 see MainActivity 
 
 */
class AndroidLikeTests: XCTestCase {
    private static let AAMServerAddress: String = "https://symbiote-dev.man.poznan.pl/coreInterface/"
    //private var keyStorePassword: String = "KEYSTORE_PASSWORD";
    private var icomUsername: String = "icom";
    private var icomPassword: String = "icom";
    private var platformId: String = "SymbIoTe_Core_AAM";
    private var clientId: String = "1ef55ca2-206a-11e8-b467-0ed5f89f718b";
    //private var keyStoreFilename: String = "/keystore.jks";
    private var clientSH: SecurityHandler = SecurityHandler(homeAAMAddress: AndroidLikeTests.AAMServerAddress)
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetSecurityRequest() {
        let aams = clientSH.getAvailableAams()
        
        let coreAam = clientSH.getCoreAAMInstance()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
