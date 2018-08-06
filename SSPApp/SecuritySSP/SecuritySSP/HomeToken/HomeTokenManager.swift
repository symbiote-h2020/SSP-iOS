//
//  HomeTokenManager.swift
//  SecuritySSP
//
//  Copyright © 2018 PSNC. All rights reserved.
//

import Foundation

class HomeTokenManager {
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
    
    
    public static func getHomeToken(iss: String = "icom", sub: String = "1ef55ca2-206a-11e8-b467-0ed5f89f718b") {
        let manager = KeyPair.manager
        try? manager.deleteKeyPair()
        
        let expirationTime: TimeInterval = 60
        let jwt = JWT(issuer: iss, subject: sub, keysManager: manager)
        let token = jwt.createToken(expiresAfter: expirationTime)
        
        
        let url = URL(string: "https://symbiote-dev.man.poznan.pl/coreInterface/get_home_token")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "x-auth-token")

        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(err.localizedDescription)
                logError(error.debugDescription)
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation, object: notiInfoObj)
            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logWarn("response status: \(status)")
                    
                }
                //debug
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                logVerbose("datastring= \(dataString ?? "    ")")
                
                
            }
            NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation)
        }
        
        task.resume()
        
    }
    
}
