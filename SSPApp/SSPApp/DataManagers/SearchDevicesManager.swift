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
        //let url = URL(string: Constants.restApiUrl + "/innkeeper/list_resources")
                let url = URL(string: "http://217.72.97.9:8080/innkeeper/public_resources/") //debug - data from
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET" //post for core
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //adding request body
        let json: [String: Any] = ["id": "appId"]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        
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
                    logError("response status: \(status)")
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
//        if dataJson["resources"].exists() == false {
//            logWarn("+++++++ wrong json +++++  SearchDevicesManager dataJson = \(dataJson)")
//
//            let notiInfoObj  = NotificationInfo(type: ErrorType.wrongResult, info: "wrong json from API")
//            NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded, object: notiInfoObj)
//            self.getBackupTestData()
//            return
//        }
        
        //let jsonArr:[JSON] = dataJson["resources"].arrayValue
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
    
    
    //MOTYLA NOGA - czemu to się nie chce sparsować
    public func getBackupTestData() {
//    //    let str = "{\"a\":[]}"
//        let str = "\"resources\":[        {           \"platformId\":\"Error device\",         \"platformName\":\"NoDevices found\",         \"owner\":null,         \"name\":\"dimmer service\",       \"id\":\"593943acb4f8e209390e9425\",         \"description\":\"dimmer\",         \"locationName\":\"\" } ]"
//        
//        let json = JSON(jsonString: str)
//        self.parseDevicesJson(json)
        
        logWarn("+++  no devices found getting debug test data +++")
        
        let dev = SmartDevice.makeDebugTestDevice()
        devicesList.append(dev)
        
        NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded)
    }
    
    
    
}
