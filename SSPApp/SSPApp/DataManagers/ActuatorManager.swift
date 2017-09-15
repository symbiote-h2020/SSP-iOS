//
//  ActuatorManager.swift
//  SSPApp
//
//  Created by Konrad Leszczyński on 15/09/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActuatorManager {
    
    func sendRequest(_ smartDeviceId: String) {
        let url = URL(string: Constants.restApiUrl + "/rap/Actuator/" + smartDeviceId)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //adding request body
        let json: [String: Any] = ["id": "appId"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        
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
    
}
