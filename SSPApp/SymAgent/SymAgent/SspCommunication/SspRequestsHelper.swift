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
    
    /**
     Platforms or SDEV can request to be registered in a Smart Space. The Registration procedure for a Smart Device is provided by using the lightweight security protocol. The message body of the registration request is encrypted and formatted as follow:
     •    Regarding the field symId (i.e. the symbIoTe id), if this is the first time the device connects to symbIoTe, then it should be an empty field; the innkeeper then responds with the id that device should save in the Flash memory (if L4) and it should re-use in future interactions with the symbIoTe ecosystem.
     •    PluginId and pluginURL are metadata used by the RAP.  The pluginURL is the ip:port/path where the RAP sends the request to the SDEV.
     •    Roaming indicates if the SDEV is a L3 or L4 device to the innkeeper during the registration
     •    The field dk1 represents the current session key.
     •    Regarding the hashField could be
        o    all 0 when the SDEV joins for the first time or
        o    hashField = H(symId || previous dk1)     
     */
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
