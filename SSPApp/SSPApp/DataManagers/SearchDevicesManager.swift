//
//  SearchDevicesManager.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 10/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON


public class SearchDevicesManager {
    
    public var devicesList: [SmartDevice] = []

    public init() {}
    
    public func getTestDataFromCloud() {
        let url = URL(string: "https://symbiote-dev.man.poznan.pl:8100/coreInterface/v1/query") //debug - data from
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("", forHTTPHeaderField: "X-Auth-Token")  //TODO: proper secure token
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)

                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded, object: notiInfoObj)

                self.getBackupTestData()
            }
            else {
                //debug
//                let dataString = String(data: data!, encoding: String.Encoding.utf8)
//                logVerbose(dataString)
                
                if let jsonData = data {
                    do {
                        let json = try JSON(data: jsonData)
                        self.parseDevicesJson(json)
                    } catch {
                        logError("getTestDataFromCloud json")
                    }
                }

            }
        }
        
        task.resume()
    }
    
    public func getResourceList() {
        //core https://symbiote-open.man.poznan.pl/coreInterface/query
        //let url = URL(string: "https://symbiote-open.man.poznan.pl/coreInterface/query?id=5ae314283a6fd805304869ca")
        //https://symbiote-open.man.poznan.pl:8777/query?homePlatformId=SymbIoTe_Core_AAM
        //let url = URL(string: "https://symbiote-open.man.poznan.pl:8777/query?homePlatformId=SymbIoTe_Core_AAM")
        let url = URL(string: GlobalSettings.restApiUrl + "/innkeeper/public_resources/")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        request.setValue("\(DateTime.Now.unixEpochTime()*1000)", forHTTPHeaderField: "x-auth-timestamp")
//        request.setValue("1", forHTTPHeaderField: "x-auth-size")
//        //request.setValue(TokensManager.shared.makeXAuth1RequestHeader(), forHTTPHeaderField: "x-auth-1")
//        request.setValue(TokensManager.shared.makeXAuth1RequestHeader_DebugTest(), forHTTPHeaderField: "x-auth-1")
        
//        //adding request body for core
//        let json: [String: Any] = ["id": "appId"]
//        let jsonData = try? JSONSerialization.data(withJSONObject: json)
//        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if let err = error {
                logError(error.debugDescription)
                
                let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: err.localizedDescription)
                NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded, object: notiInfoObj)
                
                self.getBackupTestData()
            }
            else {
                let status = (response as! HTTPURLResponse).statusCode
                if (status >= 400) {
                    logError("response status: \(status)  \(response.debugDescription)")
                    let notiInfoObj  = NotificationInfo(type: ErrorType.connection, info: "response status: \(status)")
                    NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded, object: notiInfoObj)
                }
                //debug
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                logVerbose(dataString)
                
                
                if let jsonData = data {
                    do {
                        let json = try JSON(data: jsonData)
                        self.parseDevicesJson(json)
                    } catch {
                        logError("getResourceList json")
                    }
                }
                
            }
        }
        
        task.resume()
    }
    
    
    public func parseDevicesJson(_ dataJson: JSON) {
        let jsonArr:[JSON] = dataJson.arrayValue
        for childJson in jsonArr {
            
            let dev = SmartDevice(childJson)
            devicesList.append(dev)
        }
        
        if devicesList.count == 0 {
            getBackupTestData()
            let notiInfoObj  = NotificationInfo(type: ErrorType.emptySet, info: "No devices found")
            NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded, object: notiInfoObj)
        }
        else {
            NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded)
        }
    }
    
    
    public func getBackupTestData() {
        logWarn("+++  no devices found getting debug test data +++")
        
        let dev = SmartDevice.makeDebugTestDevice()
        devicesList.append(dev)
        
        NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded)
    }
    
    
    
}
