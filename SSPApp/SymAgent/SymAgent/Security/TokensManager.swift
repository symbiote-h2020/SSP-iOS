//
//  TokensManager.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 11/02/2018.
//  Copyright © 2018 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

public class TokensManager {
    // MARK: - Properties
    public static let shared = TokensManager(Constants.restApiUrl)
    
    public var guestToken: String = ""
    
    let baseURL: URL
    
    // Initialization
    private init(_ strUrl: String) {
        let baseURL = URL(string: strUrl)
        self.baseURL = baseURL!
    }
    
    public func getGuestToken() {
        //let url = URL(string: "https://symbiote-dev.man.poznan.pl/coreInterface/get_guest_token") //debug - token from core
        let url = URL(string: Constants.restApiUrl + "/saam/get_guest_token")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.Security, object: notiInfoObj)
            }
            else {
                if let httpResponse = response as? HTTPURLResponse
                {
                    //logVerbose("response header for guest_token request:  \(httpResponse.allHeaderFields)")
                    if let xAuthToken = httpResponse.allHeaderFields["x-auth-token"] as? String {
                        //log("gouest_token = \(xAuthToken)")
                        self.guestToken = xAuthToken
                    }
                }
            }
        }
        
        task.resume()
    }
 
    public func makeXAuth1RequestHeader() -> String {
        let json = JSON(
                ["token":self.guestToken,
                 "authenticationChallenge":"",
                 "clientCertificate":"",
                 "clientCertificateSigningAAMCertificate":"",
                 "foreignTokenIssuingAAMCertificate":""
                 ]
        )
        
        log(json.rawString(options: []))
        //let str = "{\"token\":\"\(TokensManager.shared.guestToken)\":\"\" }"
        return json.rawString(options: []) ?? "couldn't build request json"
    }
}
