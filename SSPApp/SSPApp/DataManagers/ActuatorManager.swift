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
        let url = URL(string: Constants.restApiUrl + "/rap/Actuator/" + smartDeviceId)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //adding request body
        let dict = buildActionsDict(valuesList)
        
        let json: [String: Any] = [
            "id": smartDeviceId,
            "action" : dict
            ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        //debug
        let dataString = String(data: jsonData!, encoding: String.Encoding.utf8)
        logVerbose("sending actuator json: \n" + dataString!)

        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.ActuatorAction, object: notiInfoObj)
            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("response status: \(status)")
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
}
