//
//  SearchDevicesManager.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 10/07/2017.
//  Copyright © 2017 PSNC. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchDevicesManager {
    var devicesList: [SmartDevice] = []

    func getTestData() {
//debug test
//        self.getBackupTestData()
//        return
        
        
        let url = URL(string: "https://symbiote-dev.man.poznan.pl:8100/coreInterface/v1/query")

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
                let dataString = String(data: data!, encoding: String.Encoding.utf8)
                logVerbose(dataString)
                
                if let jsonData = data {
                    let json = JSON(data: jsonData)
                    self.parseDevicesJson(json)
                }

            }
        }
        
        task.resume()
    }
    
    
    func parseDevicesJson(_ dataJson: JSON) {
        if dataJson["resources"].exists() == false {
            logWarn("+++++++ wrong json +++++  SearchDevicesManager dataJson = \(dataJson)")
            
            let notiInfoObj  = NotificationInfo(type: ErrorType.wrongResult, info: "wrong json from API")
            NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded, object: notiInfoObj)
            
            return
        }
        
        let jsonArr:[JSON] = dataJson["resources"].arrayValue
        for childJson in jsonArr {
            
            let dev = SmartDevice(j: childJson)
            devicesList.append(dev)
        }
        
        NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded)
    }
    
    
    //MOTYLA NOGA - czemu to się nie chce sparsować
    func getBackupTestData() {
//    //    let str = "{\"a\":[]}"
//        let str = "\"resources\":[        {           \"platformId\":\"Error device\",         \"platformName\":\"NoDevices found\",         \"owner\":null,         \"name\":\"dimmer service\",       \"id\":\"593943acb4f8e209390e9425\",         \"description\":\"dimmer\",         \"locationName\":\"\" } ]"
//        
//        let json = JSON(jsonString: str)
//        self.parseDevicesJson(json)
        
        let dev = SmartDevice.makeDebugTestDevice()
        devicesList.append(dev)
        
        NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded)
    }
    
    
    
}