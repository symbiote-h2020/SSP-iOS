//
//  JWT.swift
//  Demo-iOS
//
//  Created by Sebastian Mamczak on 30.07.2018.
//  Copyright © 2018 Agens AS. All rights reserved.
//

import Foundation
import EllipticCurve

enum JWTAlgorithm: String {
    case ES256 = "ES256"
}

class JWT {
    
    let algorithm: JWTAlgorithm
    let issuer: String
    let subject: String
    let keysManager: EllipticCurveKeyPair.Manager
    
    init(algorithm: JWTAlgorithm = .ES256, issuer: String, subject: String, keysManager: EllipticCurveKeyPair.Manager) {
        self.algorithm = algorithm
        self.issuer = issuer
        self.subject = subject
        self.keysManager = keysManager
    }
    
    func createToken(expiresAfter: TimeInterval) -> String {
        let header = createHeader()
        let payload = createPayload(expirationTime: expiresAfter)
        let signatureInput = "eyJhbGciOiJFUzI1NiJ9.eyJpc3MiOiJ0ZXN0dXNlcm5hbWUiLCJzdWIiOiJ0ZXN0Y2xpZW50aWQiLCJpYXQiOjE1MDE1MDk3ODIsImV4cCI6MTUwMTUwOTg0Mn0"
        //self.base64(header) + "." + self.base64(payload)
        let signature = createSignature(signatureInput)
        
        return signatureInput + "." + signature
    }
}

extension JWT {
    
    fileprivate func createHeader() -> String {
        return "{\"alg\":\"\(self.algorithm.rawValue)\"}"
    }
    
    fileprivate func createPayload(expirationTime: TimeInterval) -> String {
        //let iat = Epoch().getString()
        //let exp = Epoch(after: expirationTime).getString()
        let iat = "1501509782"
        let exp = "1501509842"
        return "{\"iss\":\"\(self.issuer)\",\"sub\":\"\(self.subject)\",\"iat\":\(iat),\"exp\":\(exp)}"
    }
    
    fileprivate func base64(_ input: String) -> String {
        guard let data = input.data(using: .utf8) else {
            fatalError("Cannot create data")
        }
        let result = data.base64EncodedString(options: .init(rawValue: 0))
        return filterBase64(result)
    }
    
    fileprivate func createSignature(_ input: String) -> String {
        let privkey: UInt256 = 1
        func hashFunc(m: Data) -> UInt256 {
            return UInt256(1234567890)
        }
       
        var data = input.data(using: .utf8)
        //let signature = try? keysManager.sign(data, hash: .sha256)
        var signature = ECDSA<Secp256k1>.sign(message: Data(), signedBy: privkey, hashedBy: hashFunc)

        var result = signature.base64EncodedString(options: .init(rawValue: 0))
        return filterBase64(result)
    }
    
    private func filterBase64(_ input: String) -> String {
        return input
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
