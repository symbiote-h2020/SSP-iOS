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
    var devicesList: [Device] = []

    func getTestData() {
//debug test
        self.getBackupTestData()
        return
        
        
        let url = URL(string: "https://symbiote-dev.man.poznan.pl:8100/coreInterface/v1/query")

        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("", forHTTPHeaderField: "X-Auth-Token")  //TODO: proper secure token
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data,response,error in
            if error != nil {
                print(error)
                //TODO error alert
                self.getBackupTestData()
            }
            else {
               // let dataString = String(data: data!, encoding: String.Encoding.utf8)
                 // debug               print(dataString)
                
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
            print("+++++++ wrong json +++++  SearchDevicesManager")
            return
        }
        
        let jsonArr:[JSON] = dataJson["resources"].arrayValue
        for childJson in jsonArr {
            
            let dev = Device(j: childJson)
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
        
        let dev = Device()
        dev.id="aa"
        dev.name="Error"
        dev.locationName="Not found"
        dev.platformName=""
        devicesList.append(dev)
        
        NotificationCenter.default.postNotificationName(SymNotificationName.DeviceListLoaded)
    }
    
    
    
}
