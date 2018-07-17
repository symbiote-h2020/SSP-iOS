//
//  SspRequestsHelper.swift
//  SymAgent
//
//  Created by Konrad Leszczyński on 12/05/2018.
//  Copyright © 2018 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Documentation for RestAPI https://colab.intracom-telecom.com/pages/viewpage.action?spaceKey=SYM&title=Interface+Innkeeper
class SspRequestsHelper {
    
    public func register(_ sdev: SdevInfo) {
        let url = URL(string: GlobalSettings.restApiUrl + "/innkeeper/sdev/register")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonStr = sdev.toJsonRequestBody().rawString()
        request.httpBody = jsonStr?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("response status: \(status)  \(response.debugDescription)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)
                }
                //debug
                //                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                //                logVerbose(dataString)
            }
        }
        
        task.resume()
    }
    
    public func unregister(_ sdev: SdevInfo) {
        let url = URL(string: GlobalSettings.restApiUrl + "/innkeeper/sdev/unregister")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonStr = sdev.idToJson().rawString()
        request.httpBody = jsonStr?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("response status: \(status)  \(response.debugDescription)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)
                }
            }
        }
        
        task.resume()
    }
    

    public func join(_ sdev: SdevInfo) {
        let url = URL(string: GlobalSettings.restApiUrl + "/innkeeper/sdev/join")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonStr = sdev.testJoinRequestBody().rawString()
        request.httpBody = jsonStr?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("response status: \(status)  \(response.debugDescription)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)
                }
                //debug
                //                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                //                logVerbose(dataString)
            }
        }
        
        task.resume()
    }
    
    public func keepAlive(_ sdev: SdevInfo) {
        let url = URL(string: GlobalSettings.restApiUrl + "/innkeeper/sdev/keep_alive")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonStr = sdev.idToJson().rawString()
        request.httpBody = jsonStr?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("response status: \(status)  \(response.debugDescription)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.InnkeeperCommunication, object: notiInfoObj)
                }
            }
        }
        
        task.resume()
    }
    
}
