//
//  Device.swift
//  SymbioteSpike
//
//  Created by Konrad Leszczyński on 13/07/2017.
//  Copyright © 2017 Konrad Leszczyński. All rights reserved.
//

import Foundation
import SwiftyJSON


class SmartDevice {
    var platformId: String = ""
    var platformName: String = ""
    var owner: String =  ""
    var name: String = ""
    var id: String = ""
    var deviceDescription: String = ""
    
    //location
    var locationName: String = ""
    var locationLatitude: String = ""
    var locationLongitude: String = ""
    var locationAltitude: String = ""
    
    //array
    var observedProperties: [String] = [String]()
    var resourceType: [String] = [String]()
    
    convenience init(j: JSON)  {
        self.init()
        
        if j["platformId"].exists()     { platformId = j["platformId"].stringValue }
        if j["platformName"].exists()   { platformName = j["platformName"].stringValue }
        if j["owner"].exists()          { owner = j["owner"].stringValue }
        if j["name"].exists()           { name = j["name"].stringValue }
        if j["id"].exists()             { id = j["id"].stringValue }
        if j["description"].exists()    { deviceDescription = j["description"].stringValue }
        
        //location
        if j["locationName"].exists()           { locationName = j["locationName"].stringValue }
        if j["locationLatitude"].exists()       { locationLatitude = j["locationLatitude"].stringValue }
        if j["locationLongitude"].exists()      { locationLongitude = j["locationLongitude"].stringValue }
        if j["locationAltitude"].exists()       { locationAltitude = j["locationAltitude"].stringValue }

        if j["observedProperties"].exists() {
            for oP in j["observedProperties"].arrayValue {
                observedProperties.append(oP.stringValue)
            }
        }
        if j["resourceType"].exists() {
            for r in j["resourceType"].arrayValue {
                resourceType.append(r.stringValue)
            }
        }

    }
    
    
    static func makeDebugTestDevice() -> SmartDevice {
        let dev = SmartDevice()
        dev.id="aa"
        dev.name="Error"
        dev.locationName="Not found"
        dev.platformName="No devices"
        dev.deviceDescription="Debug test device in case of error"
        return dev
    }
    
}
