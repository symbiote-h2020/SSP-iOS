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
    public static let shared = TokensManager(GlobalSettings.restApiUrl)
    
    public var sspGuestToken: String = ""
    public var coreGuestToken: String = ""
    
    let baseURL: URL
    
    // Initialization
    private init(_ strUrl: String) {
        let baseURL = URL(string: strUrl)
        self.baseURL = baseURL!
    }
    
    ///slightly different url for tokenns for SSP and core (also different notificationsNames)
    public func getCoreGuestToken() {
        let url = URL(string: GlobalSettings.coreInterfaceApiUrl + "/get_guest_token")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.SecurityTokenCore, object: notiInfoObj)
            }
            else {
                if let httpResponse = response as? HTTPURLResponse
                {
                    //logVerbose("response header for guest_token request:  \(httpResponse.allHeaderFields)")
                    if let xAuthToken = httpResponse.allHeaderFields["x-auth-token"] as? String {
                        //log("core gouest_token = \(xAuthToken)")
                        self.coreGuestToken = xAuthToken
                        NotificationCenter.default.postNotificationName(SymNotificationName.SecurityTokenCore)
                    }
                }
            }
        }
        
        task.resume()
    }
    
    ///slightly different url for tokenns for SSP and core (also different notificationsNames)
    public func getSSPGuestToken() {
        let url = URL(string: GlobalSettings.restApiUrl + "/saam/get_guest_token")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.SecurityTokenSSP, object: notiInfoObj)
            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("getSSPGuestToken() response status: \(status)  \(response.debugDescription)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.SecurityTokenSSP, object: notiInfoObj)
                }
                
                if let httpResponse = response as? HTTPURLResponse
                {
                    //logVerbose("response header for guest_token request:  \(httpResponse.allHeaderFields)")
                    if let xAuthToken = httpResponse.allHeaderFields["x-auth-token"] as? String {
                        //log("ssp gouest_token = \(xAuthToken)")
                        self.sspGuestToken = xAuthToken
                        NotificationCenter.default.postNotificationName(SymNotificationName.SecurityTokenSSP)
                    }
                }
            }
        }
        
        task.resume()
    }
 
    public func makeXAuth1SSPRequestHeader() -> String {
        let json = JSON(
                ["token":self.sspGuestToken,
                 "authenticationChallenge":"",
                 "clientCertificate":"",
                 "clientCertificateSigningAAMCertificate":"",
                 "foreignTokenIssuingAAMCertificate":""
                 ]
        )
        
        log(json.rawString(options: []))
        return json.rawString(options: []) ?? "couldn't build request json"
    }
    
    public func makeXAuth1CoreRequestHeader() -> String {
        let json = JSON(
            ["token":self.coreGuestToken,
             "authenticationChallenge":"",
             "clientCertificate":"",
             "clientCertificateSigningAAMCertificate":"",
             "foreignTokenIssuingAAMCertificate":""
            ]
        )
        
        log(json.rawString(options: []))
        return json.rawString(options: []) ?? "couldn't build request json"
    }
    
    public func makeXAuth1RequestHeader_DebugTest() -> String {
        let json = JSON(
            ["token":"eyJhbGciOiJFUzI1NiJ9.eyJ0dHlwIjoiR1VFU1QiLCJzdWIiOiJndWVzdCIsImlwayI6Ik1Ga3dFd1lIS29aSXpqMENBUVlJS29aSXpqMERBUWNEUWdBRXQwVExQODBZUDFHWHhiVXErYkd5ZGdFZzRuNzFqVkRVTVdBYXoxbTBkam5LL0lldUlSL3lWNGNLSnZnTzlST3pMZUVNODBzbThMQ0JkTCtzYW9wdzZRPT0iLCJpc3MiOiJTeW1iSW9UZV9Db3JlX0FBTSIsImV4cCI6MTUyNzAwMDMyNCwiaWF0IjoxNTI3MDAwMjY0LCJqdGkiOiIxNzQwNjU1NjMyIiwic3BrIjoiTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFUi96OC9xczFvRUpqd0VNWWd5djhqU2lwUVZ5K2ZPZUlyc0FkQW90M09RZG1VOVEzRDJoRmhsSjVleTgwMlNPcmxsWWNBS2FzbUF1bDRTdWljSUJhUWc9PSJ9.lRGpPscwKkpGhlHONbxEFcG38tkWs9Q5mvQFMT_PIWI5zJPJLwj3mypQnB4ossd6iKvtfSMVFfGg0q_v0PDtrA",
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
