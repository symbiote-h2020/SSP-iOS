//
//  JWTTests.swift
//  SecuritySSPTests
//
//  Created by Konrad Leszczyński on 30/07/2018.
//  Copyright © 2018 Konrad. All rights reserved.
//

import XCTest
@testable import SecuritySSP

class JWTTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
