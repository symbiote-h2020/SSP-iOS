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
    
    /// declaration of this function in java is: public Certificate getCertificate(AAM homeAAM, String username, String password, String clientId)
    public func getCertificate(aamUrl: String, username: String, password: String, clientId: String) -> String {
        var certyficateString = ""
        let csr = buildPlatformCertificateSigningRequestPEM()
        
        let json: [String: Any] = [  "username" : username,
                                     "password" : password,
                                     "clientId" : clientId,
                                     "clientCSRinPEMFormat" : "\(csr)"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        //url eg.
        let url = URL(string: "https://symbiote-dev.man.poznan.pl/coreInterface/sign_certificate_request")
        //let url = URL(string: aamUrl + SecurityConstants.AAM_SIGN_CERTIFICATE_REQUEST)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let semaphore = DispatchSemaphore(value: 0)
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
                certyficateString = String(data: data!, encoding: String.Encoding.utf8) ?? ""
                logVerbose("datastring= \(certyficateString)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return certyficateString
    }
    
    
    private func buildPlatformCertificateSigningRequestPEM(cn: String = "icom@clientId@SymbIoTe_Core_AAM") -> String {//(platformId, KeyPair keyPair)

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
