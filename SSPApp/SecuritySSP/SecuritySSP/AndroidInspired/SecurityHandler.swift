//
//  SecurityHandler.swift
//  SecuritySSP
//
//  Created by Konrad Leszczyński
//  Copyright © 2018 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON
import CertificateSigningRequestSwift

/**
  SecurityHandler class is designe to work exactly as its counterpart on android /java code
 see https://github.com/symbiote-h2020/SymbIoTeSecurity/blob/master-android/src/main/java/eu/h2020/symbiote/security/handler/SecurityHandler.java
 names of methods are the same
 */
public class SecurityHandler {
    private var homeAAMAddress: String
    private var platformId: String
    
    var coreAAM: Aam?
    var availableAams = [String:Aam]()
    
    
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
    
    init(homeAAMAddress: String, platformId: String = "") {
        self.homeAAMAddress = homeAAMAddress
        self.platformId = platformId
    }
    
    
    public func getAvailableAams() -> [String:Aam] {
        var aams = [String:Aam]()
        let semaphore = DispatchSemaphore(value: 0)  //1. create a counting semaphore
        getAvailableAams(self.homeAAMAddress) {dictOfAams in
            aams = dictOfAams
            semaphore.signal()  //3. count it up
        }
        semaphore.wait()  //2. wait for finished counting
        return aams
    }
    
    public func getCoreAAMInstance() -> Aam? {
        if let val = self.availableAams[SecurityConstants.CORE_AAM_INSTANCE_ID] {
            return val
        }
        else {
            return nil
        }
    }
    
    /**
     - Parameter aamAddress:  Address where the user can reach REST endpoints used in security layer of SymbIoTe
     */
    public func getAvailableAams(_ aamAddress: String, finished: @escaping ((_ dictOfAams: [String:Aam])->Void))   {
        let url = URL(string: aamAddress + SecurityConstants.AAM_GET_AVAILABLE_AAMS)!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation, object: notiInfoObj)
            }
            else {
                if let httpResponse = response as? HTTPURLResponse
                {
                    let status = httpResponse.statusCode
                    if (status >= 400) {
                        logWarn("response status: \(status)")
                        logError("getAvailableAams json")
                        let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "wrong http status code")
                        NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation, object: notiInfoObj)
                    }

                    if let jsonData = data {
                        do {
                            let json = try JSON(data: jsonData)
                            self.availableAams = self.parseAamsJson(json)
                            NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation)
                            finished(self.availableAams)
                        } catch {
                            logError("getAvailableAams json")
                            let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "wrong data json")
                            NotificationCenter.default.postNotificationName(SymNotificationName.CoreCommunictation, object: notiInfoObj)
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
    
    private func parseAamsJson(_ dataJson: JSON) -> [String:Aam] {
        var aams = [String:Aam]()
        
        if dataJson["availableAAMs"].exists() == false {
            logWarn("+++++++ wrong json +++++  parseAamsJson dataJson = \(dataJson)")
        }
        else {
            let jsonArr:JSON = dataJson["availableAAMs"]
            for (_, subJson) in jsonArr {
                //logVerbose("AAM name = \(key)")
                let a = Aam(subJson)
                aams[a.aamInstanceId] = a
            }
        }
        
        return aams
    }
    
    //public Certificate getCertificate(AAM homeAAM, String username, String password, String clientId)
    public func requestCSR() {
        
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
            privateKey = try SecurityHandler.KeyPair.manager.privateKey().underlying
        }
        catch {
            logError("Error: \(error)")
        }
        
        publicKeyBits = try! SecurityHandler.KeyPair.manager.publicKey().data().raw
        
        //Initiale CSR
        let csr = CertificateSigningRequest(commonName: cn, organizationName: nil, organizationUnitName: nil, countryName: nil, stateOrProvinceName: nil, localityName: nil, keyAlgorithm: keyAlgorithm)

        
        guard let csrBuild2 = csr.buildCSRAndReturnString(publicKeyBits!, privateKey: privateKey!) else {
            return ""
        }
        logVerbose("CSR string with header and footer")
        logVerbose(csrBuild2)
        
        return csrBuild2
        
    }
}
