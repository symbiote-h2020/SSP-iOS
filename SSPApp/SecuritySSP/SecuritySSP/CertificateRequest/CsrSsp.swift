//
//  CsrSsp.swift
//  SecuritySSP
//
//  Created by Konrad Leszczyński on 06/07/2018.
//  Copyright © 2018 Konrad. All rights reserved.
//

import Foundation
import LocalAuthentication
//import EllipticCurveKeyPair
import CertificateSigningRequestSwift

class CsrSsp {
    struct Shared {
        static let keypair: EllipticCurveKeyPair.Manager = {
            EllipticCurveKeyPair.logger = { print($0) }
            let publicAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAlwaysThisDeviceOnly, flags: [])
            let privateAccessControl = EllipticCurveKeyPair.AccessControl(protection: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly, flags: {
                return EllipticCurveKeyPair.Device.hasSecureEnclave ? [.userPresence, .privateKeyUsage] : [.userPresence]
            }())
            let config = EllipticCurveKeyPair.Config(
                publicLabel: "no.agens.sign.public",
                privateLabel: "no.agens.sign.private",
                operationPrompt: "Sign transaction",
                publicKeyAccessControl: publicAccessControl,
                privateKeyAccessControl: privateAccessControl,
                token: .secureEnclaveIfAvailable)
            return EllipticCurveKeyPair.Manager(config: config)
        }()
    }
    
    
    func requestCSR() {
        
        let csr = buildPlatformCertificateSigningRequestPEM()
        
        let json: [String: Any] = [  "username" : "icom",
                                     "password" : "icom",
                                     "clientId" : "clientId",
                                     "clientCSRinPEMFormat" : "\(csr)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://symbiote-dev.man.poznan.pl/coreInterface/sign_certificate_request")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(err.localizedDescription)
                logError(error.debugDescription)
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
        }
        
        task.resume()
    }
    
    
    private func buildPlatformCertificateSigningRequestPEM() -> String {//(platformId, KeyPair keyPair)
        //let cn = "CN=icom@clientId@SymbIoTe_Core_AAM" //with this I get: "400: ERR_INVALID_ARGUMENTS"
        //let cn = "CN=icom" //with this I get "400 invalid argument"
        let cn = "icom@clientId@SymbIoTe_Core_AAM"
        
        var privateKey: SecKey?
        var publicKeyBits: Data?
        
        let keyAlgorithm = KeyAlgorithm.ec(signatureType: .sha256)
        
        do {
            privateKey = try Shared.keypair.privateKey().underlying
        }
        catch {
            NSLog("Error: \(error)")
        }
        
        publicKeyBits = try! Shared.keypair.publicKey().data().raw
        
        //Initiale CSR
        let csr = CertificateSigningRequest(commonName: cn, organizationName: nil, organizationUnitName: nil, countryName: nil, stateOrProvinceName: nil, localityName: nil, keyAlgorithm: keyAlgorithm)
        //let csr = CertificateSigningRequest(commonName: cn, organizationName: "Test", organizationUnitName: "Test", countryName: "US", stateOrProvinceName: "KY", localityName: "Test", keyAlgorithm: keyAlgorithm)
        //Build the CSR
        //        guard let csrBuild = csr.buildAndEncodeDataAsString(publicKeyBits!, privateKey: privateKey!) else {
        //            return ""
        //        }
        //        print("CSR string no header and footer")
        //        print(csrBuild)
        
        guard let csrBuild2 = csr.buildCSRAndReturnString(publicKeyBits!, privateKey: privateKey!) else {
            return ""
        }
        print("CSR string with header and footer")
        print(csrBuild2)
        
        return csrBuild2
        
    }
}
