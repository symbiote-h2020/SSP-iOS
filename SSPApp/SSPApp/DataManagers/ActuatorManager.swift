//
//  ActuatorManager.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 15/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON


public class ActuatorManager {
    public init() {}
    
    public func sendRequest(_ smartDeviceId: String, valuesList: [ActuatorsValue]) {
        let strUrl = GlobalSettings.restApiUrl + "/rap/Actuator/" + smartDeviceId

        //let strUrl = "\(GlobalSettings.restApiUrl)/rap/Actuator('\(smartDeviceId)')"
        
        log(strUrl)
        let url = URL(string: strUrl)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("\(DateTime.Now.unixEpochTime()*1000)", forHTTPHeaderField: "x-auth-timestamp")
        request.setValue("1", forHTTPHeaderField: "x-auth-size")
        request.setValue(TokensManager.shared.makeXAuth1SSPRequestHeader(), forHTTPHeaderField: "x-auth-1")
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        //adding request body
//        let dict = buildActionsDict(valuesList)
//
//        let json: [String: Any] = [
//            "id": smartDeviceId,
//            "action" : dict
//            ]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        request.httpBody = jsonData
        
        let jsonStr = buidFakeTestRequest().rawString()
        request.httpBody = jsonStr?.data(using: .utf8)
        

        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.ActuatorAction, object: notiInfoObj)
            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("response status: \(status) \(response.debugDescription)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.ActuatorAction, object: notiInfoObj)
                }
                //debug
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                logVerbose(dataString)
                
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.noErrorSuccessfulFinish, info: "OK - action send")
                NotificationCenter.default.postNotificationName(SymNotificationName.ActuatorAction, object: notiInfoObj)
                
            }
        }
        
        task.resume()
    }
    
    private func buildActionsDict(_ valuesList: [ActuatorsValue]) -> [String: Int] {
        var retDict = [String: Int]()
        
        for v in valuesList {
            retDict[v.name] = v.value
        }
        
        return retDict
    
    }
    
    private func buidFakeTestRequest() -> JSON {
        let json = JSON(
        ["RGBCapability":[
            ["r":5],
            ["g":5],
            ["b":5]
            ]]
        )
        
        log(json.rawString(options: []))
        return json
    }
    
    
    /*
    private func buildRequestBody() -> JSON{
        let json = JSON(
        {"RGBCapability": [
            {"r":5}
                ]}
        )
        
        log(json.rawString(options: []))
        return json
    }
 */
}
