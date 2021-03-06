//
//  SSPAppTests.swift
//  SSPAppTests
//
//  Created by Konrad Leszczyński on 31/07/2018.
//  Copyright © 2018 PSNC. All rights reserved.
//

import XCTest
@testable import SecuritySSP


class SSPAppTests: XCTestCase {
    struct KeyPair {
        static let manager: EllipticCurveKeyPair.Manager = {
            let publicAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAlwaysThisDeviceOnly, flags: [])
            let privateAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, flags: {
                return EllipticCurveKeyPair.Device.hasSecureEnclave ? [.userPresence, .privateKeyUsage] : [.userPresence]
            }())
            let config = EllipticCurveKeyPair.Config(
                publicLabel: "n.sign.public",
                privateLabel: "n.sign.private",
                operationPrompt: "n Ident",
                publicKeyAccessControl: publicAccessControl,
                privateKeyAccessControl: privateAccessControl,
                token: .secureEnclaveIfAvailable)
            return EllipticCurveKeyPair.Manager(config: config)
        }()
    }
    
    
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
    
    func testJWT() {
        let manager = KeyPair.manager
        try? manager.deleteKeyPair()
        
        
        let pk = try! manager.publicKey()
        let pkdata = try! pk.data()
        log("pkdata.PEM= \(pkdata.PEM)")
        
        
        let expirationTime: TimeInterval = 60
        let jwt = JWT(issuer: "testusername", subject: "testclientid", keysManager: manager)
        let token = jwt.createToken(expiresAfter: expirationTime)
        
        log("token =")
        log(token)
        //        let pk = try! manager.publicKey()
        //        let pkdata = try! pk.data()
        //        log("pkdata.PEM= \(pkdata.PEM)")
    }
    
    func testHomeToken() {
        HomeTokenManager.getHomeToken()
        
        if waitForNotificationNamed(SymNotificationName.CoreCommunictation.rawValue) {
            XCTAssertTrue(CoreAAM_Manager.shared.aams.count >= 1 , "There are some AAMs")
        }
    }
    
    func waitForNotificationNamed(_ notificationName: String) -> Bool {
        let expectation = XCTNSNotificationExpectation(name: NSNotification.Name(rawValue: notificationName))
        let result = XCTWaiter().wait(for: [expectation], timeout: 5)
        log("waitForNotificationNamed result = \(result.rawValue)")
        return result == .completed
    }
}
