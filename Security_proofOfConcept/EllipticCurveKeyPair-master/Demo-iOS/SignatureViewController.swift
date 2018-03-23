/**
 *  Copyright (c) 2017 Håvard Fossli.
 *
 *  Licensed under the MIT license, as follows:
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in all
 *  copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  SOFTWARE.
 */

import UIKit
import LocalAuthentication
import EllipticCurveKeyPair
import CertificateSigningRequestSwift

class SignatureViewController: UIViewController {
    
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
    
    var context: LAContext! = LAContext()
    
    @IBOutlet weak var publicKeyTextView: UITextView!
    @IBOutlet weak var digestTextView: UITextView!
    @IBOutlet weak var signatureTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let key = try Shared.keypair.publicKey().data()
            publicKeyTextView.text = key.PEM
        } catch {
            publicKeyTextView.text = "Error: \(error)"
        }
    }
    
    @IBAction func regeneratePublicKey(_ sender: Any) {
        context = LAContext()
        do {
            try Shared.keypair.deleteKeyPair()
            let key = try Shared.keypair.publicKey().data()
            publicKeyTextView.text = key.PEM
        } catch {
            publicKeyTextView.text = "Error: \(error)"
        }
    }
    
    var cycleIndex = 0
    let digests = ["Lorem ipsum dolor sit amet", "mei nibh tritani ex", "exerci periculis instructior est ad"]
    
    @IBAction func createDigest(_ sender: Any) {
        cycleIndex += 1
        digestTextView.text = digests[cycleIndex % digests.count]
    }
    
    @IBAction func sign(_ sender: Any) {
        
        /*
         Using the DispatchQueue.roundTrip defined in Utils.swift is totally optional.
         What's important is that you call `sign` on a different thread than main.
         */
        
        DispatchQueue.roundTrip({
            guard let digest = self.digestTextView.text?.data(using: .utf8) else {
                throw "Missing text in unencrypted text field"
            }
            return digest
        }, thenAsync: { digest in
            return try Shared.keypair.signUsingSha256(digest, context: self.context)
        }, thenOnMain: { digest, signature in
            self.signatureTextView.text = signature.base64EncodedString()
            try Shared.keypair.verifyUsingSha256(signature: signature, originalDigest: digest)
            try printVerifySignatureInOpenssl(manager: Shared.keypair, signed: signature, digest: digest, hashAlgorithm: "sha256")
        }, catchToMain: { error in
            self.signatureTextView.text = "Error: \(error)"
        })
    }
    
    
    @IBAction func sendSymbioteSSPRequestTapped_dynamic(_ sender: Any) {
        NSLog("sendSymbioteSSPRequestTapped")
        testSend()
        //TestCSR.start()
    }
    
    func testSend() {
        
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
                NSLog(error.debugDescription)
                
                
            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    NSLog("response status: \(status)")
                    
                }
                //debug
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                NSLog("datastring= \(dataString)")
                
                
            }
        }
        
        task.resume()
    }
    
    func buildPlatformCertificateSigningRequestPEM() -> String {//(platformId, KeyPair keyPair)
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


public class TestCSR {
    
    private var publicKey: SecKey?
    private var privateKey: SecKey?
    private var keyBlockSize: Int?
    private var publicKeyBits: Data?
    
    let tagPublic = "com.csr.public"
    let tagPrivate = "com.csr.private"
    let keyAlgorithm = KeyAlgorithm.ec(signatureType: .sha256)
    

}


